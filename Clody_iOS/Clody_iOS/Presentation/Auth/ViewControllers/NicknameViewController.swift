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
            textFieldInputEvent: clodyTextField.textField.rx.text.orEmpty.asSignal(onErrorJustReturn: ""),
            textFieldDidBeginEditing: clodyTextField.textField.rx.controlEvent(.editingDidBegin).asSignal(),
            textFieldDidEndEditing: textFieldDidEndEditing,
            nextButtonTapEvent: rootView.nextButton.rx.tap.asSignal(), 
            backButtonTapEvent: rootView.navigationBar.backButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
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
            .drive(onNext: { isEnabled in
                self.rootView.nextButton.setEnabledState(to: isEnabled)
            })
            .disposed(by: disposeBag)
        
        output.pushViewController
            .drive(onNext: {
                guard let nickname = self.clodyTextField.textField.text else { return }
                self.signUpWithKakao(nickname: nickname)
            })
            .disposed(by: disposeBag)
        
        output.popViewController
            .drive(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension NicknameViewController {
    
    func signUpWithKakao(nickname: String) {
        viewModel.signUpWithKakao(nickname: nickname) {
            self.navigationController?.pushViewController(DiaryNotificationViewController(), animated: true)
        }
    }
}
