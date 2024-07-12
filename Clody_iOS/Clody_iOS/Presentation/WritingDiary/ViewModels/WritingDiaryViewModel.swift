//
//  WritingDiaryModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import RxSwift
import RxCocoa

final class WritingDiaryViewModel: CalendarViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let tapSaveButton: Signal<Void>
        let tapAddButton: Signal<Void>
    }
    
    struct Output {
        let items: Driver<[String]>
        let statuses: Driver<[Bool]>
    }
    
    let writingDiaryDataRelay = BehaviorRelay<WritingDiaryModel>(value: WritingDiaryModel(date: "", content: [""]))
    let itemsRelay = BehaviorRelay<[String]>(value: [""])
    let textViewStatusRelay = BehaviorRelay<[Bool]>(value: [true])
    let textDidEditing = PublishRelay<String>()
    let textEndEditing = PublishRelay<String>()
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                // 초기 데이터 로드 로직 추가 가능
            })
            .disposed(by: disposeBag)
        
        input.tapSaveButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                // 저장 버튼 클릭 로직 추가 가능
            })
            .disposed(by: disposeBag)
        
        input.tapAddButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                var items = self.itemsRelay.value
                var statuses = self.textViewStatusRelay.value
                if items.count < 5 {
                    items.append("")
                    statuses.append(true)
                    self.itemsRelay.accept(items)
                    self.textViewStatusRelay.accept(statuses)
                }
            })
            .disposed(by: disposeBag)
        
        let items = itemsRelay
            .map { data -> [String] in
                print(data)
                return data
            }
            .asDriver(onErrorJustReturn: [])
        
        let statuses = textViewStatusRelay
            .map { data -> [Bool] in
                print(data)
                return data
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(items: items, statuses: statuses)
    }
}
