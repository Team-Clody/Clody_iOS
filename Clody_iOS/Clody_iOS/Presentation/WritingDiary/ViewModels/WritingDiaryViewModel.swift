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
        let kebabButtonTap: PublishRelay<Int>
    }
    
    struct Output {
        let items: Driver<[WritingDiarySection]>
        let statuses: Driver<[Bool]>
        let isFirst: Driver<[Bool]>
        let popToCalendar: Signal<Void>
        let isAddButtonEnabled: Driver<Bool>
        let showSaveErrorToast: Signal<Void>
        let showSaveAlert: Signal<Void>
        let showDelete: Signal<Int>
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
        
        input.kebabButtonTap
            .bind(to: showDeleteRelay)
            .disposed(by: disposeBag)
        
        let items = diariesRelay
            .map { diaries in
                [WritingDiarySection(header: "Diary Header", items: diaries)]
            }
            .asDriver(onErrorJustReturn: [])
        
        let statuses = textViewIsEmptyRelay
            .asDriver(onErrorJustReturn: [])
        
        let isFirst = isFirstRelay
            .asDriver(onErrorJustReturn: [])
        
        let popToCalendar = input.tapBackButton.asSignal()
        
        let isAddButtonEnabled = diariesRelay
            .map { $0.count < 5 }
            .asDriver(onErrorJustReturn: true)
        
        let showSaveErrorToast = showSaveErrorToastRelay.asSignal()
        
        let showSaveAlert = showSaveAlertRelay.asSignal()
        
        let showDelete = showDeleteRelay.asSignal()
        
        return Output(
            items: items,
            statuses: statuses,
            isFirst: isFirst,
            popToCalendar: popToCalendar,
            isAddButtonEnabled: isAddButtonEnabled,
            showSaveErrorToast: showSaveErrorToast,
            showSaveAlert: showSaveAlert, 
            showDelete: showDelete
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
    
    private func saveData() {
        // 데이터 저장 로직 추가
        // writingDiaryDataRelay를 이용해 데이터를 저장할 수 있음
        if diariesRelay.value.contains("") {
            self.showSaveErrorToastRelay.accept(())
        } else {
            self.showSaveAlertRelay.accept(())
        }
    }
    
    private func deleteData(index: Int) {
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
}
