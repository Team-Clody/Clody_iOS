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
    
    func signInWithKakao(oauthToken: OAuthToken, completion: @escaping (Bool) -> ()) {
        UserManager.shared.platform = "kakao"
        APIConstants.authCode = oauthToken.accessToken
        Providers.authProvider.request(
            target: .signIn(data: LoginRequestDTO(platform: UserManager.shared.platformValue)),
            instance: BaseResponse<LoginResponseDTO>.self
        ) { response in
            if response.status == 200 {
                guard let data = response.data else { return }
                UserManager.shared.updateToken(
                    data.accessToken,
                    data.refreshToken
                )
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func signInWithApple(completion: @escaping () -> ()) {
        UserManager.shared.platform = "apple"
        completion()
    }
}
