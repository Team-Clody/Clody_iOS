import UIKit

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

final class AccountViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = AccountViewModel()
    private let disposeBag = DisposeBag()
    private let maxLength = 10
    
    // MARK: - UI Components
    
    private let rootView = AccountView()
    private lazy var changeNicknameBottomSheet = ChangeNicknameBottomSheet()
    private var alert: ClodyAlert?
    private lazy var dimmingView = UIView()
    private var tapGestureDisposable: Disposable?
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setKeyboardNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Extensions
    
    private func bindViewModel() {
        let input = AccountViewModel.Input(
            backButtonTapEvent: rootView.navigationBar.backButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.popViewController
            .drive(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        changeNicknameBottomSheet.textField.textField.rx.text
            .orEmpty
            .map { String($0.prefix(self.maxLength)) }
            .bind(to: self.changeNicknameBottomSheet.textField.textField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isLogoutButtonEnabled
            .bind(to: rootView.logoutButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        changeNicknameBottomSheet.textField.textField.rx.text
            .orEmpty
            .map { $0.count }
            .subscribe(onNext: { [weak self] count in
                self?.changeNicknameBottomSheet.textField.countLabel.text = "\(count)"
            })
            .disposed(by: disposeBag)
        
        changeNicknameBottomSheet.textField.textField.rx.text
            .orEmpty
            .map { !$0.isEmpty }
            .subscribe(onNext: { isEnabled in
                self.changeNicknameBottomSheet.doneButton.setEnabledState(to: isEnabled)
            })
            .disposed(by: disposeBag)
        
        viewModel.getUserInfoAPI { [weak self] userInfo in
            self?.rootView.nicknameLabel.text = userInfo.name
            self?.rootView.emailLabel.text = userInfo.email
        }
        
        output.userInfo
            .drive(onNext: { [weak self] name, email in
                self?.rootView.nicknameLabel.text = name
                self?.rootView.emailLabel.text = email
            })
            .disposed(by: disposeBag)
        
        rootView.changeProfileButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showChangeNicknameBottomSheet()
            })
            .disposed(by: disposeBag)
        
        changeNicknameBottomSheet.navigationBar.xButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hideChangeNicknameBottomSheet()
            })
            .disposed(by: disposeBag)
        
        changeNicknameBottomSheet.doneButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hideChangeNicknameBottomSheet()
                guard let nickname = self?.changeNicknameBottomSheet.textField.textField.text else { return }
                self?.viewModel.patchNickNameChange(nickname: nickname) { nickname in
                    self?.rootView.nicknameLabel.attributedText = UIFont.pretendardString(text: nickname, style: .body1_semibold)
                }
            })
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
                            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                sceneDelegate.changeRootViewController(LoginViewController(), animated: true)
                            }
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
                        self.viewModel.withdraw() { statusCode in
                            self.hideAlert()
                            
                            switch statusCode {
                            case 200:
                                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                    sceneDelegate.changeRootViewController(LoginViewController(), animated: true)
                                }
                            default:
                                // TODO: Show Error Alert
                                print("😵 서버 통신 실패 - 회원탈퇴에 실패했습니다.")
                            }
                        }
                        self.hideAlert()
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
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

private extension AccountViewController {
    
    func showChangeNicknameBottomSheet() {
        setBottomSheet()
        view.layoutIfNeeded()
        
        changeNicknameBottomSheet.transform = CGAffineTransform(translationX: 0, y: changeNicknameBottomSheet.frame.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmingView.alpha = 1
            self.changeNicknameBottomSheet.transform = .identity
        })
    }
    
    func hideChangeNicknameBottomSheet() {
        tapGestureDisposable?.dispose()
        tapGestureDisposable = nil
        
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmingView.alpha = 0
            self.changeNicknameBottomSheet.transform = CGAffineTransform(translationX: 0, y: self.changeNicknameBottomSheet.frame.height)
        }) { _ in
            self.dimmingView.removeFromSuperview()
            self.changeNicknameBottomSheet.removeFromSuperview()
        }
    }
    
    func setBottomSheet() {
        dimmingView.alpha = 0
        dimmingView.backgroundColor = .black.withAlphaComponent(0.4)
        view.addSubviews(dimmingView, changeNicknameBottomSheet)
        
        dimmingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        changeNicknameBottomSheet.snp.makeConstraints {
            $0.height.equalTo(272)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        tapGestureDisposable = dimmingView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.hideChangeNicknameBottomSheet()
            })
        tapGestureDisposable!.disposed(by: disposeBag)
    }
    
    func showAlert(
        type: AlertType,
        title: String,
        message: String,
        rightButtonText: String
    ) {
        self.alert = ClodyAlert(type: type, title: title, message: message, rightButtonText: rightButtonText)
        setAlert()
        view.layoutIfNeeded()
        
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
        dimmingView.alpha = 1
        dimmingView.backgroundColor = .black.withAlphaComponent(0.4)
        view.addSubviews(dimmingView, alert!)
        
        dimmingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alert!.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.center.equalToSuperview()
        }
    }
}
