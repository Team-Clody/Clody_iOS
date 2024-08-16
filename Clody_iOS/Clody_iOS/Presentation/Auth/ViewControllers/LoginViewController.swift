//
//  LoginViewController.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/11/24.
//

import AuthenticationServices
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
    private lazy var signUpInfo = SignUpInfoModel(
        platform: "",
        email: "",
        name: ""
    )
    
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
        let input = LoginViewModel.Input(
            kakaoLoginButtonTapEvent: rootView.kakaoLoginButton.rx.tap.asSignal(),
            appleLoginButtonTapEvent: rootView.appleLoginButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.signInWithKakao
            .drive(onNext: {
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        self.signInWithKakao(error, oauthToken)
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                        self.signInWithKakao(error, oauthToken)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.signInWithApple
            .drive(onNext: {
                self.signInWithApple()
            })
            .disposed(by: disposeBag)
    }
    
    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
}

private extension LoginViewController {
    
    func signInWithKakao(_ error: Error?, _ oauthToken: OAuthToken?) {
        if let error = error {
            print("❗️카카오 로그인 실패 - \(error)")
        } else {
            print("✅ 카카오 로그인 성공")
            UserApi.shared.me() { (user, error) in
                if let error = error {
                    print("❗️유저 정보 가져오기 실패 - \(error)")
                } else {
                    if let oauthToken = oauthToken {
                        self.viewModel.signIn(authCode: oauthToken.accessToken) { statusCode in
                            self.handleResultForStatus(statusCode: statusCode, platform: .kakao)
                        }
                    }
                }
            }
        }
    }
    
    func signInWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = []
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func handleResultForStatus(statusCode: Int, platform: LoginPlatformType) {
        switch statusCode {
        case 200:
            /// 로그인 성공
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.changeRootViewController(CalendarViewController(), animated: true)
            }
        case 404:
            /// 존재하지 않는 유저
            self.signUpInfo.platform = UserManager.shared.platformValue
            self.handleResultForPlatform(platform: platform)
        default:
            print("😵 서버 에러 - 로그인에 실패했습니다.")
        }
    }
    
    func handleResultForPlatform(platform: LoginPlatformType) {
        switch platform {
        case .apple:
            self.navigationController?.pushViewController(EmailViewController(signUpInfo: self.signUpInfo), animated: true)
        case .kakao:
            self.navigationController?.pushViewController(TermsViewController(signUpInfo: self.signUpInfo), animated: true)
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credential.identityToken
        else { return }
        print("✅ 애플 로그인 성공")
        
        guard let idToken = String(data: identityToken, encoding: .utf8) else { return }
        print("💳 idToken: \(idToken)")
        
        viewModel.signIn(idToken: idToken) { statusCode in
            self.handleResultForStatus(statusCode: statusCode, platform: .apple)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❗️Apple login failed - \(error.localizedDescription)")
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
