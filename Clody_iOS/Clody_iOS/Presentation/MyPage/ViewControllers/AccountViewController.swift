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
        setActions()
        setKeyboardNotifications()
        
        self.navigationItem.hidesBackButton = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Extensions
    
    private func bindViewModel() {
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

            let attributedTitle = UIFont.pretendardString(text: "x", style: .body1_medium)
            $0.setAttributedTitle(attributedTitle, for: .normal)
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
            $0.width.height.equalTo(20)
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
}

import SwiftUI

struct AccountViewControllerPreview: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> AccountViewController {
        return AccountViewController()
    }

    func updateUIViewController(_ uiViewController: AccountViewController, context: Context) {}
}

#if DEBUG
struct AccountViewControllerPreview_Previews: PreviewProvider {

    static var previews: some View {
        AccountViewControllerPreview()
            .previewDevice("iPhone 12")
    }
}

#endif
