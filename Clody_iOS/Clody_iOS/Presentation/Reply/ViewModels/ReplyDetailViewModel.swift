//
//  ReplyDetailViewModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/14/24.
//

import UIKit

import RxCocoa
import RxSwift

final class ReplyDetailViewModel: ViewModelType {
    
    struct Input {
        let okButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let dismissAlert: Driver<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let dismissAlert = input.okButtonTapEvent
            .asDriver(onErrorJustReturn: Void())
        
        return Output(dismissAlert: dismissAlert)
    }
}
