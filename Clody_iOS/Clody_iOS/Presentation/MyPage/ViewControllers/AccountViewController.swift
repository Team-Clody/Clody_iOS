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

    // MARK: - Life Cycles

    override func loadView() {
        super.loadView()
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
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
                let alertVC = ClodyAlertViewController(
                    type: .logout,
                    title: "로그아웃 하시겠어요?",
                    message: "기다릴게요, 다음에 다시 만나요!",
                    rightButtonText: "로그아웃"
                )

                alertVC.alertView.leftButton.rx.tap
                    .subscribe(onNext: { [weak alertVC] in
                        alertVC?.dismiss(animated: true, completion: nil)
                    })
                    .disposed(by: self.disposeBag)

                alertVC.alertView.rightButton.rx.tap
                    .subscribe(onNext: { [weak alertVC] in
                        alertVC?.dismiss(animated: true, completion: nil)
                    })
                    .disposed(by: self.disposeBag)

                self.present(alertVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        rootView.deleteAccountButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let alertVC = ClodyAlertViewController(
                    type: .withdraw,
                    title: "서비스를 탈퇴하시겠어요?",
                    message: "작성하신 일기와 받은 답장 및 클로버가 모두 삭제되며 복구할 수 없어요.",
                    rightButtonText: "탈퇴할래요"
                )

                alertVC.alertView.leftButton.rx.tap
                    .subscribe(onNext: { [weak alertVC] in
                        alertVC?.dismiss(animated: true, completion: nil)
                    })
                    .disposed(by: self.disposeBag)

                alertVC.alertView.rightButton.rx.tap
                    .subscribe(onNext: { [weak alertVC] in
                        alertVC?.dismiss(animated: true, completion: nil)
                    })
                    .disposed(by: self.disposeBag)

                self.present(alertVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        nicknameTextField.textField.rx.text.orEmpty
            .map { "\($0.count)/10" }
            .bind(to: nicknameTextField.countLabel.rx.text)
            .disposed(by: disposeBag)

        setActions()
        setKeyboardNotifications()
        setDelegate()
    }

    private func setActions() {
        rootView.changeProfileButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showNicknameChangeAlert()
            })
            .disposed(by: disposeBag)
    }

    private func showNicknameChangeAlert() {
        let nicknameChangeView = SettingNicknameChangeView()
        nicknameChangeView.nicknameTextField.textField.placeholder = rootView.nicknameLabel.text
        nicknameChangeView.bindActions()

        view.addSubview(nicknameChangeView)

        nicknameChangeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        nicknameChangeView.changeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let newNickname = nicknameChangeView.nicknameTextField.textField.text, !newNickname.isEmpty else { return }
                self?.rootView.nicknameLabel.text = newNickname
                nicknameChangeView.removeFromSuperview()
            })
            .disposed(by: disposeBag)

        nicknameChangeView.closeButton.rx.tap
            .subscribe(onNext: {
                nicknameChangeView.removeFromSuperview()
            })
            .disposed(by: disposeBag)
    }

    @objc private func handleChangeNickname() {
        guard let newNickname = nicknameTextField.textField.text, !newNickname.isEmpty else { return }
        rootView.nicknameLabel.text = newNickname
        view.subviews.last?.removeFromSuperview()
    }

    @objc private func handleCloseButton() {
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

extension AccountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 10
    }
}
