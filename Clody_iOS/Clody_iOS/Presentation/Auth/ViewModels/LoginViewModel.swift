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
    
    func signInWithKakao(oauthToken: OAuthToken, completion: @escaping () -> ()) {
        UserManager.shared.platForm = "kakao"
        APIConstants.authCode = oauthToken.accessToken
        Providers.authProvider.request(
            target: .signIn(data: LoginRequestDTO(platform: UserManager.shared.platFormValue)),
            instance: BaseResponse<LoginResponseDTO>.self
        ) { response in
            print(response)
            guard let data = response.data else { return }
            UserManager.shared.updateToken(
                data.accessToken,
                data.refreshToken
            )
        }
        completion()
    }
}
