//
//  TermsViewModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/15/24.
//

import UIKit

import RxCocoa
import RxSwift

final class TermsViewModel: ViewModelType {
    
    struct Input {
        let allAgreeTextButtonTapEvent: Signal<Bool>
        let allAgreeIconButtonTapEvent: Signal<Bool>
        let agreeTermsButtonTapEvent = BehaviorRelay<Bool>(value: false)
        let agreePrivacyButtonTapEvent = BehaviorRelay<Bool>(value: false)
        let nextButtonTapEvent: Signal<Void>
        let backButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let twoAgreeCombineEvent: Driver<Bool>
        let allAgreeButtonMergeEvent: Driver<Bool>
        let nextButtonIsEnabled: Driver<Bool>
        let pushViewController: Driver<Void>
        let popViewController: Driver<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let twoAgreeCombineEvent = Observable
            .combineLatest(
                input.agreeTermsButtonTapEvent,
                input.agreePrivacyButtonTapEvent
            )
            .map { values in
                return values.0 && values.1
            }
            .asDriver(onErrorJustReturn: false)
        
        let allAgreeButtonMergeEvent = Signal
            .merge(
                input.allAgreeTextButtonTapEvent,
                input.allAgreeIconButtonTapEvent
            )
            .asDriver(onErrorJustReturn: false)

        let nextButtonIsEnabled = Signal
            .merge(
                twoAgreeCombineEvent.asSignal(onErrorJustReturn: false),
                allAgreeButtonMergeEvent.asSignal(onErrorJustReturn: false)
            )
            .asDriver(onErrorJustReturn: false)
        
        let pushViewController = input.nextButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        let popViewController = input.backButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            twoAgreeCombineEvent: twoAgreeCombineEvent,
            allAgreeButtonMergeEvent: allAgreeButtonMergeEvent,
            nextButtonIsEnabled: nextButtonIsEnabled,
            pushViewController: pushViewController,
            popViewController: popViewController
        )
    }
}
