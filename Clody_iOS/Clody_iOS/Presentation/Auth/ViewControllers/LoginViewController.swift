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
                self.navigationController?.pushViewController(TermsViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }

    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
}
