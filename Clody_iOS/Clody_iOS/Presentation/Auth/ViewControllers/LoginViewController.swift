//
//  LoginViewController.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/11/24.
//

import UIKit

import RxCocoa
import RxSwift
import Then
import KakaoSDKUser

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
        
        rootView.kakaoLoginButton.rx.tap
            .bind(onNext: testAPI)
            .disposed(by: disposeBag)
    }
}

// MARK: - Extensions

private extension LoginViewController {

    func bindViewModel() {
        let input = LoginViewModel.Input(kakaoLoginButtonTapEvent: rootView.kakaoLoginButton.rx.tap.asSignal())
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.loginWithKakao
            .drive(onNext: {
                self.navigationController?.pushViewController(TermsViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }

    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
}


func testAPI() {
    let provider = Providers.calendarProvider
    
    provider.request(target: .getDailyDiary(year: 2023, month: 1, dat: 22), instance: BaseResponse<CalendarDiaryResponseDTO>.self) { data in
            print(data)
        
        print(data.message)
    }
}


func handleKakaoLogin() {
    if (UserApi.isKakaoTalkLoginAvailable()) {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            if let oauthToken = oauthToken{
                print(oauthToken)
                let idToken = oauthToken.accessToken
                print("🍀",idToken)
            }
        }
    } else {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print("🍀",error)
            }
            if let oauthToken = oauthToken{
                print("kakao success")
            }
        }
    }
}
