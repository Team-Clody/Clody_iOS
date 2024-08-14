//
//  EmailViewModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 8/12/24.
//

import UIKit

import RxCocoa
import RxSwift

enum EmailInputResult {
    case empty
    case error
    case normal
}

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
        let nextButtonIsEnabled = BehaviorRelay<Bool>(value: false)
        let errorMessage: Driver<EmailInputResult>
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
        
        let errorMessage = input.textFieldInputEvent
            .map { text in
                if text.count == 0 { return EmailInputResult.empty }
                
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                if let _ = text.range(of: emailRegEx, options: .regularExpression) {
                    return EmailInputResult.normal
                } else {
                    return EmailInputResult.error
                }
            }
            .asDriver(onErrorJustReturn: EmailInputResult.empty)
        
        let pushViewController = input.nextButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        let popViewController = input.backButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            isTextFieldFocused: isTextFieldFocused,
            errorMessage: errorMessage,
            pushViewController: pushViewController,
            popViewController: popViewController
        )
    }
}
