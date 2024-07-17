//
//  OnBoardingViewModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/16/24.
//

import UIKit

import RxCocoa
import RxSwift

final class OnBoardingViewModel: ViewModelType {
    
    struct Input {
        let nextButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let changePageIndex: Driver<Void>
        let pushViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let changePageIndex = input.nextButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            changePageIndex: changePageIndex
        )
    }
}
