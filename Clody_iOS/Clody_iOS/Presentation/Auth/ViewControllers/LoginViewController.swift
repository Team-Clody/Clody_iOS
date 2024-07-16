//
//  LoginViewController.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/11/24.
//

import UIKit

import KakaoSDKAuth
import KakaoSDKUser
import RxCocoa
import RxSwift
import Then

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let rootView = LoginView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setUI()
    }
}
    
// MARK: - Extensions

private extension LoginViewController {
    
    func bindViewModel() {
        let input = LoginViewModel.Input(kakaoLoginButtonTapEvent: rootView.kakaoLoginButton.rx.tap.asSignal())
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.loginWithKakao
            .drive(onNext: {
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        self.loginWithKakao(error, oauthToken)
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                        self.loginWithKakao(error, oauthToken)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
}

private extension LoginViewController {
    
    func loginWithKakao(_ error: Error?, _ oauthToken: OAuthToken?) {
        if let error = error {
            print("❗️카카오 로그인 실패 - \(error)")
        } else {
            print("✅ 카카오 로그인 성공")
            UserApi.shared.me() { (user, error) in
                if let error = error {
                    print("❗️유저 정보 가져오기 실패 - \(error)")
                } else {
                    if let user = user {
                        let provider = Providers.authProvider
                        //                        provider.request(target: .login(data: LoginRequestDTO(platform: "kakao")),
                        //                                         instance: BaseResponse<LoginResponseDTO>.self,
                        //                                         completion: {
                        //                            data in
                        //                                print(data)
                        //                            })
                        self.viewModel.loginWithKakao { response in
                            self.navigationController?.pushViewController(TermsViewController(), animated: true)
                        }
                    }
                }
            }
        }
    }
}
