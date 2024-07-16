//
//  LoginViewModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/15/24.
//

import UIKit

import RxCocoa
import RxSwift

final class LoginViewModel: ViewModelType {
    
    struct Input {
        let kakaoLoginButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let loginWithKakao: Driver<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let loginWithKakao = input.kakaoLoginButtonTapEvent
            .asDriver(onErrorJustReturn: Void())
        return Output(loginWithKakao: loginWithKakao)
    }
}

extension LoginViewModel {
    
    func loginWithKakao(completion: @escaping (Any) -> ()) {
//        AuthAPI.shared.loginWithKakao() { response in
//            completion(response as Any)
//        }
    }
}
