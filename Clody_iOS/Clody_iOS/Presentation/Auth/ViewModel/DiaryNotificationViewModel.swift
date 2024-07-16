//
//  DiaryNotificationViewModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/16/24.
//

import UIKit

import RxCocoa
import RxSwift

final class DiaryNotificationViewModel: ViewModelType {
    
    struct Input {
        let timeSettingViewTapEvent: Signal<Void>
        let completeButtonTapEvent: Signal<Void>
        let setNextButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let showBottomSheet: Driver<Void>
        let pushViewController: Driver<Void>
    }
    
    let selectedTimeRelay = BehaviorRelay<[String]>(value: ["오후", "9", "30"])
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let showBottomSheet = input.timeSettingViewTapEvent
            .asDriver(onErrorJustReturn: ())
            
        let pushViewController = Signal
            .merge(
                input.completeButtonTapEvent,
                input.setNextButtonTapEvent
            )
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            showBottomSheet: showBottomSheet,
            pushViewController: pushViewController
        )
    }
}
