//
//  WritingDiaryViewModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import RxSwift
import RxCocoa

final class WritingDiaryViewModel: ViewModelType {
    
    struct Input {
        let tapSubmitButton: Signal<Void>
        let tapAddButton: Signal<Void>
        let tapBackButton: Signal<Void>
        let updateKebobRelay: PublishRelay<Int>
        let tapDeleteButton: Signal<Void>
        let tapHelpInfoButton: Signal<Void>
        let tapCancelButton: Signal<Void>
    }
    
    struct Output {
        let diaryItems: Driver<[DiaryItem]>
        let showDraftAlert: Signal<Void>
        let isAddButtonEnabled: Driver<Bool>
        let showSubmitErrorToast: Signal<Void>
        let showSubmitAlert: Signal<Void>
        let showDelete: Signal<Void>
        let showHelp: Driver<Bool>
    }
    
    let diaryStateRelay = BehaviorRelay<DiaryState>(value: DiaryState())
    let diaryTextBufferRelay = BehaviorRelay<DiaryState>(value: DiaryState())
    private let showSubmitErrorToastRelay = PublishRelay<Void>()
    private let showSubmitAlertRelay = PublishRelay<Void>()
    private let showDeleteRelay = PublishRelay<Int>()
    private let deleteIndexRelay = BehaviorRelay<Int?>(value: nil)
    private let isHiddenHelpRelay = BehaviorRelay<Bool>(value: true)
    var currentDiaryState: DiaryState {
        diaryStateRelay.value
    }
    var currentBufferState: DiaryState {
        diaryTextBufferRelay.value
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        input.tapSubmitButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                updateDiaryState()
                if currentDiaryState.hasValidItems {
                    showSubmitAlertRelay.accept(())
                } else {
                    showSubmitErrorToastRelay.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.tapAddButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                updateDiaryState()
                AmplitudeManager.shared.trackEvent("writing_diary_add_list")
                
                let state = currentDiaryState
                state.addItem()
                updateTextBuffer(state)
                updateDiaryState()
            })
            .disposed(by: disposeBag)
        
        input.updateKebobRelay
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: deleteIndexRelay)
            .disposed(by: disposeBag)
        
        input.tapDeleteButton
            .emit(onNext: { [weak self] in
                guard let self = self, let index = deleteIndexRelay.value else { return }
                updateDiaryState()
                AmplitudeManager.shared.trackEvent("writing_diary_delete_list")
                
                let newState = currentDiaryState
                newState.removeItem(at: index)
                updateTextBuffer(newState)
                updateDiaryState()
                deleteIndexRelay.accept(nil)
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
        
        let diaryItems = diaryStateRelay
            .map { $0.items }
            .asDriver(onErrorJustReturn: [])
        
        let showDraftAlert = input.tapBackButton.asSignal()
        
        let isAddButtonEnabled = diaryStateRelay
            .map { $0.canAddItem }
            .asDriver(onErrorJustReturn: true)
        
        let showSubmitErrorToast = showSubmitErrorToastRelay.asSignal()
        
        let showSubmitAlert = showSubmitAlertRelay.asSignal()
        
        let showDelete = deleteIndexRelay
            .map { _ in }
            .asSignal(onErrorJustReturn: ())
        
        let showHelp = isHiddenHelpRelay.asDriver(onErrorJustReturn: true)
        
        return Output(
            diaryItems: diaryItems,
            showDraftAlert: showDraftAlert,
            isAddButtonEnabled: isAddButtonEnabled,
            showSubmitErrorToast: showSubmitErrorToast,
            showSubmitAlert: showSubmitAlert,
            showDelete: showDelete,
            showHelp: showHelp
        )
    }
    
    func fetchData(date: Date) {
        if let year = Int(DateFormatter.string(from: date, format: "yyyy")),
           let month = Int(DateFormatter.string(from: date, format: "MM")),
           let day = Int(DateFormatter.string(from: date, format: "dd")) {
            getDraftDiaryData(year: year, month: month, date: day) { [weak self] in
                self?.updateDiaryState()
            }
        }
    }
    
    func getCurrentTexts() -> [String] {
        currentDiaryState.getTexts()
    }
    
    func hasAnyContent() -> Bool {
        currentDiaryState.hasAnyContent
    }
    
    func updateDiaryState() {
        diaryStateRelay.accept(diaryTextBufferRelay.value)
    }
    
    func updateTextBuffer(_ newState: DiaryState) {
        diaryTextBufferRelay.accept(newState)
    }
}

extension WritingDiaryViewModel {
    
    func getDraftDiaryData(year: Int, month: Int, date: Int, completion: @escaping () -> Void) {
        let provider = Providers.diaryRouter
        
        provider.request(target: .getDraftDiaryList(year: year, month: month, date: date), instance: BaseResponse<GetDraftDiariesResponseDTO>.self) { [weak self] data in
            guard let self = self else { return }
            // TODO: 서버통신 에러 대응
            switch data.status {
            case 200..<300:
                guard let data = data.data else { return }
                let newState = DiaryState()
                newState.loadDraftData(data.draftDiaries)
                diaryTextBufferRelay.accept(newState)
                completion()
            default:
                print("error draft")
            }
        }
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
