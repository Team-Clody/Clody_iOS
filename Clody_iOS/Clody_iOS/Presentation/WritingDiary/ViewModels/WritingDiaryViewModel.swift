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
        let tapAddButton: Signal<String>
    }
    
    struct Output {
        let addItem: Driver<Void>
        let fetchData: Driver<String>
        let saveData: Driver<Void>
    }
    
    let writingDiaryDataRelay = BehaviorRelay<WritingDiaryModel>(value: WritingDiaryModel(date: "", content: []))
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
//        input.viewDidLoad
//            .subscribe(onNext: { [weak self] in
//                guard let self = self else { return }
//                writingDiaryDataRelay.accept()
//            })
//            .disposed(by: disposeBag)
//        
//        let replyDate = input.tapReplyButton
//            .asDriver(onErrorJustReturn: "")
//        
//        let kebabDate = input.tapKebabButton
//            .asDriver(onErrorJustReturn: "")
//        
//        let listData = listDummyDataRelay
//            .map { $0.diaries }
//            .asDriver(onErrorJustReturn: [])
//        
//        return Output(replyDate: replyDate, kebabDate: kebabDate)
//    }
}

extension WritingDiaryViewModel {
    
    private func loadDailyDummyData() {
        let listData = ListModel.dummy()
//        self.listDummyDataRelay.accept(listData)
    }
}
