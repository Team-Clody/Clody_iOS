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
        let tapSaveButton: Signal<Void>
        let tapAddButton: Signal<Void>
        let tapBackButton: Signal<Void>
        let updateKebobRelay: PublishRelay<Int>
        let tapDeleteButton: Signal<Void>
        let tapHelpInfoButton: Signal<Void>
        let tapCancelButton: Signal<Void>
    }
    
    struct Output {
        let items: Driver<[WritingDiarySection]>
        let statuses: Driver<[Bool]>
        let isFirst: Driver<[Bool]>
        let popToCalendar: Signal<Void>
        let isAddButtonEnabled: Driver<Bool>
        let showSaveErrorToast: Signal<Void>
        let showSaveAlert: Signal<Void>
        let showDelete: Signal<Void>
        let showHelp: Driver<Bool>
    }
    let writingDiaryDataRelay = BehaviorRelay<WritingDiaryModel>(value: WritingDiaryModel(date: "", content: [""]))
    let diariesRelay = BehaviorRelay<[String]>(value: [""])
    let textViewIsEmptyRelay = BehaviorRelay<[Bool]>(value: [true])
    let isFirstRelay = BehaviorRelay<[Bool]>(value: [true])
    let textDidEditing = PublishRelay<String>()
    let textEndEditing = PublishRelay<String>()
    private let showSaveErrorToastRelay = PublishRelay<Void>()
    private let showSaveAlertRelay = PublishRelay<Void>()
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
        
        input.tapSaveButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.saveData()
            })
            .disposed(by: disposeBag)
        
        input.tapAddButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                var items = self.diariesRelay.value
                var isEmpty = self.textViewIsEmptyRelay.value
                var isFirst = self.isFirstRelay.value
                if items.count < 5 {
                    items.append("")
                    isEmpty.append(true)
                    isFirst.append(true)
                    self.diariesRelay.accept(items)
                    self.textViewIsEmptyRelay.accept(isEmpty)
                    self.isFirstRelay.accept(isFirst)
                } else {
                    
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
                self.deleteData(index: index) {}
            })
            .disposed(by: disposeBag)
        
        input.tapHelpInfoButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                var isHiddenValue = isHiddenHelpRelay.value
                isHiddenHelpRelay.accept(!isHiddenValue)
            })
            .disposed(by: disposeBag)
        
        input.tapCancelButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                isHiddenHelpRelay.accept(true)
            })
            .disposed(by: disposeBag)
        
        let items = diariesRelay
            .observe(on: MainScheduler.asyncInstance)
            .map { diaries in
                [WritingDiarySection(header: "Diary Header", items: diaries)]
            }
            .asDriver(onErrorJustReturn: [])
        
        let statuses = textViewIsEmptyRelay
            .asDriver(onErrorJustReturn: [])
        
        let isFirst = isFirstRelay
            .asDriver(onErrorJustReturn: [])
        
        let popToCalendar = input.tapBackButton.asSignal()
        
        let isAddButtonEnabled = Observable.combineLatest(input.tapAddButton.asObservable(), diariesRelay.asObservable())
            .map { _, diaries in diaries.count < 5 }
            .asDriver(onErrorJustReturn: true)
        
        let showSaveErrorToast = showSaveErrorToastRelay.asSignal()
        
        let showSaveAlert = showSaveAlertRelay.asSignal()
        
        let showDelete = deleteIndexRelay
            .map { _ in }
            .asSignal(onErrorJustReturn: ())
        
        let showHelp = isHiddenHelpRelay.asDriver(onErrorJustReturn: true)
        
        return Output(
            items: items,
            statuses: statuses,
            isFirst: isFirst,
            popToCalendar: popToCalendar,
            isAddButtonEnabled: isAddButtonEnabled,
            showSaveErrorToast: showSaveErrorToast,
            showSaveAlert: showSaveAlert,
            showDelete: showDelete, 
            showHelp: showHelp
        )
    }
    
    private func loadInitialData() {
        let initialDiaries = [""]
        let initialStatuses = [true]
        let initialIsFirst = [true]
        
        diariesRelay.accept(initialDiaries)
        textViewIsEmptyRelay.accept(initialStatuses)
        isFirstRelay.accept(initialIsFirst)
    }
}

extension WritingDiaryViewModel {
    
    func saveData() {
        if diariesRelay.value.contains("") {
            self.showSaveErrorToastRelay.accept(())
        } else {
            self.showSaveAlertRelay.accept(())
        }
    }
    
    func deleteData(index: Int, completion: @escaping () -> ()) {
        var items = self.diariesRelay.value
        var statuses = self.textViewIsEmptyRelay.value
        var isFirst = self.isFirstRelay.value
        items.remove(at: index)
        statuses.remove(at: index)
        isFirst.remove(at: index)
        self.diariesRelay.accept(items)
        self.textViewIsEmptyRelay.accept(statuses)
        self.isFirstRelay.accept(isFirst)
    }
    
    func postDiary(date: String, content: [String], completion: @escaping (NetworkViewJudge, String) -> ()) {
        let provider = Providers.diaryRouter
        let data = PostDiaryRequestDTO(date: date, content: content)
        
        provider.request(target: .postDiary(data: data), instance: BaseResponse<PostDiaryResponseDTO>.self) { data in
            var dataStatus = NetworkViewJudge.unknowned
            switch data.status {
            case 200..<300: dataStatus = .success
            case -1: dataStatus = .network
            default: dataStatus = .unknowned
            }
            guard let data = data.data else { return }
            completion(dataStatus, data.replyType)
        }
    }
}
