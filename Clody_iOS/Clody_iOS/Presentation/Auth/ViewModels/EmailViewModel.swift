//
//  EmailViewModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 8/12/24.
//

import UIKit

import RxCocoa
import RxSwift

final class EmailViewModel: ViewModelType {
    
    struct Input {
        let textFieldInputEvent: Signal<String>
        let textFieldDidBeginEditing: Signal<Void>
        let textFieldDidEndEditing: Signal<Bool>
        let nextButtonTapEvent: Signal<Void>
        let backButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let isTextFieldFocused: Driver<Bool>
        let nextButtonIsEnabled: Driver<Bool>
        let pushViewController: Driver<Void>
        let popViewController: Driver<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let isTextFieldFocused = Signal
            .merge(
                input.textFieldDidBeginEditing.map { true },
                input.textFieldDidEndEditing
            )
            .asDriver(onErrorJustReturn: false)
        
        let nextButtonIsEnabled = input.textFieldInputEvent
            .map {
                // TODO: 이메일 유효성 검사
                return $0.count > 0
            }
            .asDriver(onErrorJustReturn: false)
        
        let pushViewController = input.nextButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        let popViewController = input.backButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            isTextFieldFocused: isTextFieldFocused,
            nextButtonIsEnabled: nextButtonIsEnabled,
            pushViewController: pushViewController,
            popViewController: popViewController
        )
    }
}
