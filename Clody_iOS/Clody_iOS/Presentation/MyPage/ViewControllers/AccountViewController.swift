import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class AccountViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = AccountViewModel()
    private let disposeBag = DisposeBag()
    private let nicknameTextField = ClodyTextField(type: .nickname)
    
    // MARK: - UI Components
    
    private let rootView = AccountView()
    private var alert: ClodyAlert?
    private lazy var dimmingView = UIView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setActions()
        setKeyboardNotifications()
        setDelegate()
        
        nicknameTextField.textField.rx.text.orEmpty
            .map { $0.count }
            .subscribe(onNext: { [weak self] count in
                self?.nicknameTextField.countLabel.text = "\(count)"
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Extensions
    
    private func bindViewModel() {
        let input = AccountViewModel.Input(backButtonTapEvent: rootView.navigationBar.backButton.rx.tap.asSignal())
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.popViewController
            .drive(onNext: {
            self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLogoutButtonEnabled
            .bind(to: rootView.logoutButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        rootView.logoutButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.showAlert(
                    type: .logout,
                    title: I18N.Alert.logoutTitle,
                    message: I18N.Alert.logoutMessage,
                    rightButtonText: I18N.Alert.logout
                )

                alert?.leftButton.rx.tap
                    .subscribe(onNext: {
                        self.hideAlert()
                    })
                    .disposed(by: self.disposeBag)
                
                alert?.rightButton.rx.tap
                    .subscribe(onNext: {
                        self.viewModel.logout() {
                            self.hideAlert()
                        }
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    
        rootView.deleteAccountButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.showAlert(
                    type: .withdraw,
                    title: I18N.Alert.withdrawTitle,
                    message: I18N.Alert.withdrawMessage,
                    rightButtonText: I18N.Alert.withdraw
                )
                
                alert?.leftButton.rx.tap
                    .subscribe(onNext: {
                        self.hideAlert()
                    })
                    .disposed(by: self.disposeBag)
                
                alert?.rightButton.rx.tap
                    .subscribe(onNext: {
                        self.viewModel.withdraw() {
                            self.hideAlert()
                        }
                        self.hideAlert()
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
     
    private func setActions() {
        rootView.changeProfileButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showNicknameChangeAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func showNicknameChangeAlert() {
        let dimmingView = UIView().then {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        }
        view.addSubview(dimmingView)
        dimmingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let nicknameChangeView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }

        let titleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.attributedText = UIFont.pretendardString(text: "닉네임 변경", style: .body2_semibold)
            $0.textColor = .grey01
        }
        
        nicknameTextField.textField.placeholder = rootView.nicknameLabel.text
        
        let changeButton = UIButton().then {
            let attributedTitle = UIFont.pretendardString(text: "변경하기", style: .body2_semibold)
            $0.setAttributedTitle(attributedTitle, for: .normal)
            $0.setTitleColor(.grey06, for: .normal)
            $0.backgroundColor = .lightYellow
            $0.layer.cornerRadius = 5
            $0.addTarget(self, action: #selector(handleChangeNickname), for: .touchUpInside)
        }
        
        let closeButton = UIButton().then {
            $0.setTitle("x", for: .normal)
            $0.setTitleColor(.grey01, for: .normal)
            $0.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        }
        
        nicknameChangeView.addSubviews(titleLabel, nicknameTextField, changeButton, closeButton)
        
        view.addSubview(nicknameChangeView)
        
        nicknameChangeView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(294)
            $0.bottom.equalTo(view.snp.bottom)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19)
            $0.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(81)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        
        changeButton.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(73)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.right.equalToSuperview().inset(22)
            $0.width.height.equalTo(24)
        }
        
        nicknameTextField.textField.becomeFirstResponder()
        
        nicknameTextField.textField.rx.text.orEmpty
            .map { !$0.isEmpty }
            .subscribe(onNext: { isValid in
                changeButton.isEnabled = isValid
                changeButton.backgroundColor = isValid ? .mainYellow : .lightYellow
                changeButton.setTitleColor(isValid ? .grey01 : .grey06, for: .normal)
            })
            .disposed(by: disposeBag)
    }

    @objc private func handleChangeNickname() {
        guard let newNickname = nicknameTextField.textField.text, !newNickname.isEmpty else { return }
            rootView.nicknameLabel.text = newNickname
        view.subviews.last?.removeFromSuperview()
        view.subviews.last?.removeFromSuperview()
    }
    
    @objc private func handleCloseButton() {
        view.subviews.last?.removeFromSuperview()
        view.subviews.last?.removeFromSuperview()
    }
    
    private func setKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            view.frame.origin.y = -keyboardHeight
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    private func setDelegate() {
        nicknameTextField.textField.delegate = self
    }
}

private extension AccountViewController {
    
    func showAlert(
        type: AlertType,
        title: String,
        message: String,
        rightButtonText: String
    ) {
        self.alert = ClodyAlert(type: type, title: title, message: message, rightButtonText: rightButtonText)
        setAlert()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.alert!.alpha = 1
        })
    }
    
    func hideAlert() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alert!.alpha = 0
        }) { _ in
            self.dimmingView.removeFromSuperview()
            self.alert!.removeFromSuperview()
        }
    }
    
    func setAlert() {
        alert!.alpha = 0
        dimmingView.backgroundColor = .black.withAlphaComponent(0.4)
        self.view.addSubviews(dimmingView, alert!)
        
        dimmingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alert!.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.center.equalToSuperview()
        }
    }
}

extension AccountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 10
    }
}
