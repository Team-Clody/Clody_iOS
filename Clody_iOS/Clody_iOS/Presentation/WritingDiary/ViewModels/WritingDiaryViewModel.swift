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
        let textDidEditing: PublishRelay<String>
        let textEndEditing: PublishRelay<String>
    }
    
    struct Output {
        let addItem: Driver<Int>
        let setTextViewStatus: Driver<Bool>
    }
    
    let writingDiaryDataRelay = BehaviorRelay<WritingDiaryModel>(value: WritingDiaryModel(date: "", content: []))
    let itemsRelay = BehaviorRelay<[String]>(value: [])
    let textViewStatusRelay = BehaviorRelay<Bool>(value: true)
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
                var items = self.itemsRelay.value ?? []
                if items.count < 5 {
                    items.append("")
                    self.itemsRelay.accept(items)
                }
            })
            .disposed(by: disposeBag)
        
        input.textDidEditing
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.textViewStatusRelay.accept(text.count <= 50)
            })
            .disposed(by: disposeBag)
        
        input.textEndEditing
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.textViewStatusRelay.accept(text.count <= 50)
            })
            .disposed(by: disposeBag)

        
        let addItem = itemsRelay
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)
        
        let setTextViewStatus = textViewStatusRelay
            .asDriver(onErrorJustReturn: true)
        
        return Output(addItem: addItem, setTextViewStatus: setTextViewStatus)
    }
}
