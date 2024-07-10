//
//  ListViewModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ListViewModel: CalendarViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let tapReplyButton: Signal<String>
        let tapKebabButton: Signal<String>
        let monthTap: Signal<String>
    }
    
    struct Output {
        let replyDate: Driver<String>
        let kebabDate: Driver<String>
    }
    
    let listDummyDataRelay = BehaviorRelay<ListModel>(value: ListModel(totalMonthlyCount: 0, diaries: []))
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.loadDailyDummyData()
            })
            .disposed(by: disposeBag)
        
        let replyDate = input.tapReplyButton
            .asDriver(onErrorJustReturn: "")
        
        let kebabDate = input.tapKebabButton
            .asDriver(onErrorJustReturn: "")
        
        let listData = listDummyDataRelay
            .map { $0.diaries }
            .asDriver(onErrorJustReturn: [])
        
        return Output(replyDate: replyDate, kebabDate: kebabDate)
    }
}

extension ListViewModel {
    
    private func loadDailyDummyData() {
        let listData = ListModel.dummy()
        self.listDummyDataRelay.accept(listData)
    }
}
