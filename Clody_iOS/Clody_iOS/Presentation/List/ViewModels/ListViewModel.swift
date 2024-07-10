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
        let tapReplyButton: Signal<Int>
        let tapKebabButton: Signal<Void>
        let monthTap: Signal<String>
    }
    
    struct Output {
        let cloverData: Driver<String>
        let listData: Driver<[Diaries]>
    }
    
    let listDummyDataRelay = BehaviorRelay<ListModel>(value: ListModel(totalMonthlyCount: 0, diaries: []))
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.loadDailyDummyData()
            })
            .disposed(by: disposeBag)
        
        input.tapReplyButton
            .emit(onNext: { [weak self] date in
                guard let self = self else { return }
                
            })
            .disposed(by: disposeBag)
        
        input.tapKebabButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                
            })
            .disposed(by: disposeBag)
        
        let cloverData = listDummyDataRelay
            .map { date -> String in
                let cloverData = "\(self.listDummyDataRelay.value.totalMonthlyCount)"
                return cloverData
            }
            .asDriver(onErrorJustReturn: "Error")
        
        let listData = listDummyDataRelay
            .map { $0.diaries }
            .asDriver(onErrorJustReturn: [])
        
        return Output(cloverData: cloverData, listData: listData)
    }
}

extension ListViewModel {
    
    private func loadDailyDummyData() {
        let listData = ListModel.dummy()
        self.listDummyDataRelay.accept(listData)
    }
}
