//
//  WritingDiaryModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

struct WritingDiarySection {
    var header: String
    var items: [Item]
}

extension WritingDiarySection: SectionModelType {
    typealias Item = String

    init(original: WritingDiarySection, items: [Item]) {
        self = original
        self.items = items
    }
}

final class WritingDiaryViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let tapSubmitButton: Signal<Void>
        let tapAddButton: Signal<Void>
        let tapBackButton: Signal<Void>
        let updateKebobRelay: PublishRelay<Int>
        let tapDeleteButton: Signal<Void>
        let tapHelpInfoButton: Signal<Void>
        let tapCancelButton: Signal<Void>
    }
    
    struct Output {
        let items: Driver<[WritingDiarySection]>
        let showDraftAlert: Signal<Void>
        let isAddButtonEnabled: Driver<Bool>
        let showSubmitErrorToast: Signal<Void>
        let showSubmitAlert: Signal<Void>
        let showDelete: Signal<Void>
        let showHelp: Driver<Bool>
    }
    
    let diaryTextsRelay = BehaviorRelay<[String]>(value: [""])
    let isPlaceholderRelay = BehaviorRelay<[Bool]>(value: Array(repeating: true, count: 5))
    private let showSubmitErrorToastRelay = PublishRelay<Void>()
    private let showSubmitAlertRelay = PublishRelay<Void>()
    private let showDeleteRelay = PublishRelay<Int>()
    private let deleteIndexRelay = BehaviorRelay<Int?>(value: nil)
    let isHiddenHelpRelay = BehaviorRelay<Bool>(value: true)
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                // 초기 데이터 로드 로직 추가 가능
                self.loadInitialData()
            })
            .disposed(by: disposeBag)
        
        input.tapSubmitButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.submitData()
            })
            .disposed(by: disposeBag)
        
        input.tapAddButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                AmplitudeManager.shared.trackEvent("writing_diary_add_list")
                var items = self.diaryTextsRelay.value
                if items.count < 5 {
                    items.append("")
                    self.diaryTextsRelay.accept(items)
                } else {
//                    ClodyToast.show(toastType: .limitFive)
                }
            })
            .disposed(by: disposeBag)
        
        input.updateKebobRelay
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: deleteIndexRelay)
            .disposed(by: disposeBag)
        
        input.tapDeleteButton
            .emit(onNext: { [weak self] in
                guard let self = self, let index = self.deleteIndexRelay.value else { return }
                self.deleteData(index: index)
                AmplitudeManager.shared.trackEvent("writing_diary_delete_list")
            })
            .disposed(by: disposeBag)
        
        input.tapHelpInfoButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                let isHiddenValue = isHiddenHelpRelay.value
                isHiddenHelpRelay.accept(!isHiddenValue)
            })
            .disposed(by: disposeBag)
        
        input.tapCancelButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                isHiddenHelpRelay.accept(true)
            })
            .disposed(by: disposeBag)
        
        
        let items: Driver<[WritingDiarySection]> = diaryTextsRelay
            .map { models in
                [WritingDiarySection(header: "Diary Header", items: models)]
            }
            .asDriver(onErrorJustReturn: [])


        let showDraftAlert = input.tapBackButton.asSignal()
        
        let isAddButtonEnabled = diaryTextsRelay
            .map { $0.count < 5 }
            .asDriver(onErrorJustReturn: true)
        
        let showSubmitErrorToast = showSubmitErrorToastRelay.asSignal()
        
        let showSubmitAlert = showSubmitAlertRelay.asSignal()
        
        let showDelete = deleteIndexRelay
            .map { _ in }
            .asSignal(onErrorJustReturn: ())
        
        let showHelp = isHiddenHelpRelay.asDriver(onErrorJustReturn: true)
        
        return Output(
            items: items,
            showDraftAlert: showDraftAlert,
            isAddButtonEnabled: isAddButtonEnabled,
            showSubmitErrorToast: showSubmitErrorToast,
            showSubmitAlert: showSubmitAlert,
            showDelete: showDelete, 
            showHelp: showHelp
        )
    }
    
    private func loadInitialData() {
        let initialItem = ""
        diaryTextsRelay.accept([initialItem])
    }
    
    func getDraftDiaryData(year: Int, month: Int, date: Int, completion: @escaping () -> Void) {
        let provider = Providers.diaryRouter
        
        provider.request(target: .getDraftDiaryList(year: year, month: month, date: date), instance: BaseResponse<GetDraftDiariesResponseDTO>.self) { [weak self] data in
            guard let self = self else { return }
            switch data.status {
            case 200..<300:
                guard let data = data.data else { return }
                
                self.diaryTextsRelay.accept(data.draftDiaries)
                completion()
            default:
                print("error draft")
            }
        }
    }

    func fetchData(date: Date) {
        if let year = Int(DateFormatter.string(from: date, format: "yyyy")),
           let month = Int(DateFormatter.string(from: date, format: "MM")),
           let day = Int(DateFormatter.string(from: date, format: "dd")) {
            getDraftDiaryData(year: year, month: month, date: day, completion: {})
        }
    }
}

extension WritingDiaryViewModel {
    
    func submitData() {
        let isInvalid = diaryTextsRelay.value.contains {
            $0.trimmingCharacters(in: .whitespacesAndNewlines).count < 2
        }

        if isInvalid {
            self.showSubmitErrorToastRelay.accept(())
        } else {
            self.showSubmitAlertRelay.accept(())
        }
    }
    
    func deleteData(index: Int) {
        var items = self.diaryTextsRelay.value
        items.remove(at: index)
        self.diaryTextsRelay.accept(items)
    }
    
    func postDiary(date: String, content: [String], completion: @escaping (NetworkViewJudge, String, Bool) -> ()) {
        let provider = Providers.diaryRouter
        let data = PostDiaryRequestDTO(date: date, content: content)
        
        provider.request(target: .postDiary(data: data), instance: BaseResponse<PostDiaryResponseDTO>.self) { data in
            var dataStatus: NetworkViewJudge
            switch data.status {
            case 200..<300: dataStatus = .success
            case -1: dataStatus = .network
            default: dataStatus = .unknowned
            }
            guard let data = data.data else { return }
            completion(dataStatus, data.replyType, data.isFromDraft)
        }
    }
    
    func postDraftDiary(date: String, content: [String], completion: @escaping (NetworkViewJudge, String) -> ()) {
        let provider = Providers.diaryRouter
        let data = PostDraftDiaryRequestDTO(date: date, draftDiaries: content)
        
        provider.request(target: .postDraftDiary(data: data), instance: BaseResponse<PostDraftDiaryResponseDTO>.self) { data in
            var dataStatus: NetworkViewJudge
            switch data.status {
            case 200..<300: dataStatus = .success
            case -1: dataStatus = .network
            default: dataStatus = .unknowned
            }
            completion(dataStatus, "")
        }
    }
}
