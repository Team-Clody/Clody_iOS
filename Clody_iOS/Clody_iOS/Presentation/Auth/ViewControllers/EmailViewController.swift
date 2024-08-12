//
//  EmailViewController.swift
//  Clody_iOS
//
//  Created by 김나연 on 8/12/24.
//

import UIKit

import RxCocoa
import RxSwift
import Then

final class EmailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = EmailViewModel()
    private let disposeBag = DisposeBag()
    private var signUpInfo: SignUpInfoModel
    
    // MARK: - UI Components
     
    private let rootView = EmailView()
    private lazy var clodyTextField = rootView.textField
    
    // MARK: - Life Cycles
    
    init(signUpInfo: SignUpInfoModel) {
        self.signUpInfo = signUpInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

private extension EmailViewController {

    func bindViewModel() {
        let textFieldDidEndEditing = clodyTextField.textField.rx.controlEvent(.editingDidEnd)
            .map {
                guard let text = self.clodyTextField.textField.text else { return false }
                return !text.isEmpty
            }
            .asSignal(onErrorJustReturn: false)
        
        let input = EmailViewModel.Input(
            textFieldInputEvent: clodyTextField.textField.rx.text.orEmpty.asSignal(onErrorJustReturn: ""),
            textFieldDidBeginEditing: clodyTextField.textField.rx.controlEvent(.editingDidBegin).asSignal(),
            textFieldDidEndEditing: textFieldDidEndEditing,
            nextButtonTapEvent: rootView.nextButton.rx.tap.asSignal(),
            backButtonTapEvent: rootView.navigationBar.backButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
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
                guard let email = self.clodyTextField.textField.text else { return }
                self.signUpInfo.email = email
                self.navigationController?.pushViewController(TermsViewController(signUpInfo: self.signUpInfo), animated: true)
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
    }

    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
}
