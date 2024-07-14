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
    }
    
    struct Output {
        let items: Driver<[WritingDiarySection]>
        let statuses: Driver<[Bool]>
        let isFirst: Driver<[Bool]>
        let popToCalendar: Signal<Void>
        let isAddButtonEnabled: Driver<Bool>
    }
    
    let writingDiaryDataRelay = BehaviorRelay<WritingDiaryModel>(value: WritingDiaryModel(date: "", content: [""]))
    let diariesRelay = BehaviorRelay<[String]>(value: [""])
    let textViewStatusRelay = BehaviorRelay<[Bool]>(value: [true])
    let isFirstRelay = BehaviorRelay<[Bool]>(value: [true])
    let textDidEditing = PublishRelay<String>()
    let textEndEditing = PublishRelay<String>()
    
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
                // 저장 버튼 클릭 로직 추가 가능
                self.saveData()
            })
            .disposed(by: disposeBag)
        
        input.tapAddButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                var items = self.diariesRelay.value
                var statuses = self.textViewStatusRelay.value
                var isFirst = self.isFirstRelay.value
                if items.count < 5 {
                    items.append("")
                    statuses.append(true)
                    isFirst.append(true)
                    self.diariesRelay.accept(items)
                    self.textViewStatusRelay.accept(statuses)
                    self.isFirstRelay.accept(isFirst)
                }
            })
            .disposed(by: disposeBag)
        
        let items = diariesRelay
            .map { diaries in
                [WritingDiarySection(header: "Diary Header", items: diaries)]
            }
            .asDriver(onErrorJustReturn: [])
        
        let statuses = textViewStatusRelay
            .asDriver(onErrorJustReturn: [])
        
        let isFirst = isFirstRelay
            .asDriver(onErrorJustReturn: [])
        
        let popToCalendar = input.tapBackButton.asSignal()
        
        let isAddButtonEnabled = diariesRelay
            .map { $0.count < 5 }
            .asDriver(onErrorJustReturn: true)
        
        return Output(
            items: items,
            statuses: statuses,
            isFirst: isFirst,
            popToCalendar: popToCalendar,
            isAddButtonEnabled: isAddButtonEnabled
        )
    }
    
    private func loadInitialData() {
        let initialDiaries = [""]
        let initialStatuses = [true]
        let initialIsFirst = [true]
        
        diariesRelay.accept(initialDiaries)
        textViewStatusRelay.accept(initialStatuses)
        isFirstRelay.accept(initialIsFirst)
    }
    
    private func saveData() {
        // 데이터 저장 로직 추가
        // writingDiaryDataRelay를 이용해 데이터를 저장할 수 있음
    }
}
