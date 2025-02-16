//
//  NicknameViewController.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/12/24.
//

import UIKit

import RxCocoa
import RxSwift
import Then

final class NicknameViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = NicknameViewModel()
    private let disposeBag = DisposeBag()
    private let maxLength = 10
    
    // MARK: - UI Components
     
    private let rootView = NicknameView()
    private lazy var clodyTextField = rootView.textField
    
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

private extension NicknameViewController {

    func bindViewModel() {
        let textFieldDidEndEditing = clodyTextField.textField.rx.controlEvent(.editingDidEnd)
            .map {
                guard let text = self.clodyTextField.textField.text else { return false }
                return !text.isEmpty
            }
            .asSignal(onErrorJustReturn: false)
        
        let input = NicknameViewModel.Input(
            textFieldInputEvent: clodyTextField.textField.rx.text.orEmpty.distinctUntilChanged().asSignal(onErrorJustReturn: ""),
            textFieldDidBeginEditing: clodyTextField.textField.rx.controlEvent(.editingDidBegin).asSignal(),
            textFieldDidEndEditing: textFieldDidEndEditing,
            nextButtonTapEvent: rootView.nextButton.rx.tap.asSignal(), 
            backButtonTapEvent: rootView.navigationBar.backButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        clodyTextField.textField.rx.text
            .orEmpty
            .map { String($0.prefix(self.maxLength)) }
            .bind(to: self.clodyTextField.textField.rx.text)
            .disposed(by: disposeBag)

        output.charCountDidChange
            .drive(onNext: { text in
                self.clodyTextField.count = text.count
            })
            .disposed(by: disposeBag)
        
        output.isTextFieldFocused
            .drive(onNext: { isFocused in
                self.clodyTextField.setFocusState(to: isFocused)
            })
            .disposed(by: disposeBag)
        
        output.nextButtonIsEnabled
            .bind(onNext: { isEnabled in
                self.rootView.nextButton.setEnabledState(to: isEnabled)
            })
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(onNext: { inputResult in
                switch inputResult {
                case .empty:
                    self.clodyTextField.hideErrorMessage()
                    output.nextButtonIsEnabled.accept(false)
                case .error:
                    self.clodyTextField.showErrorMessage(I18N.Common.nicknameError)
                    output.nextButtonIsEnabled.accept(false)
                case .normal:
                    self.clodyTextField.hideErrorMessage()
                    output.nextButtonIsEnabled.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        output.signUp
            .drive(onNext: {
                guard let nickname = self.clodyTextField.textField.text else { return }
                self.showLoadingIndicator()
                self.signUp(nickname: nickname)
            })
            .disposed(by: disposeBag)
        
        output.popViewController
            .drive(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        viewModel.errorStatus
            .bind(onNext: { networkViewJudge in
                self.hideLoadingIndicator()
                
                switch networkViewJudge {
                case .network:
                    self.showErrorAlert(isNetworkError: true)
                case .unknowned:
                    self.showErrorAlert(isNetworkError: false)
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
    }

    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension NicknameViewController {
    
    func signUp(nickname: String) {
        viewModel.signUp(nickname: nickname) { statusCode in
            self.hideLoadingIndicator()
            
            switch statusCode {
            case 201:
                /// 회원가입 성공
                self.navigationController?.pushViewController(DiaryNotificationViewController(), animated: true)
            default:
                print("😵 서버 에러 - 회원가입에 실패했습니다.")
            }
        }
    }
}
