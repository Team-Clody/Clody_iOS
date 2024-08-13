//
//  LoginViewModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/15/24.
//

import UIKit

import KakaoSDKAuth
import RxCocoa
import RxSwift

enum LoginPlatformType: String {
    case kakao = "kakao"
    case apple = "apple"
}

final class LoginViewModel: ViewModelType {
    
    struct Input {
        let kakaoLoginButtonTapEvent: Signal<Void>
        let appleLoginButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let signInWithKakao: Driver<Void>
        let signInWithApple: Driver<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let signInWithKakao = input.kakaoLoginButtonTapEvent
            .asDriver(onErrorJustReturn: Void())
        let signInWithApple = input.appleLoginButtonTapEvent
            .asDriver(onErrorJustReturn: Void())
        
        return Output(
            signInWithKakao: signInWithKakao,
            signInWithApple: signInWithApple
        )
    }
}

extension LoginViewModel {
    
    func signIn(platform: LoginPlatformType, authCode: String, completion: @escaping (Int) -> ()) {
        UserManager.shared.platform = platform.rawValue
        UserManager.shared.authCode = authCode
        APIConstants.authCode = authCode
        
        Providers.authProvider.request(
            target: .signIn(data: LoginRequestDTO(platform: UserManager.shared.platformValue)),
            instance: BaseResponse<LoginResponseDTO>.self
        ) { response in
            if response.status == 200 {
                guard let data = response.data else { return }
                UserManager.shared.updateToken(data.accessToken, data.refreshToken)
            }
            completion(response.status)
        }
    }
}
