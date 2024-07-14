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
        let dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        view.addSubview(dimmingView)
        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let nicknameChangeView = UIView()
        nicknameChangeView.backgroundColor = .white
        nicknameChangeView.layer.cornerRadius = 10
        nicknameChangeView.layer.masksToBounds = true

        let titleLabel = UILabel()
        titleLabel.text = "닉네임 변경"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        nicknameTextField.textField.text = ""
        
        let changeButton = UIButton()
        changeButton.setTitle("변경하기", for: .normal)
        changeButton.setTitleColor(.white, for: .normal)
        changeButton.backgroundColor = .systemYellow
        changeButton.layer.cornerRadius = 5
        changeButton.addTarget(self, action: #selector(handleChangeNickname), for: .touchUpInside)
        
        let closeButton = UIButton()
            closeButton.setTitle("✕", for: .normal)
            closeButton.setTitleColor(.black, for: .normal)
            closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        
        nicknameChangeView.addSubviews(titleLabel, nicknameTextField, changeButton, closeButton)
        
        view.addSubview(nicknameChangeView)
        
        nicknameChangeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(283)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(81)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(40)
        }
        
        changeButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(73)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.right.equalToSuperview().inset(22)
            make.width.height.equalTo(20)
        }
    }

    @objc private func handleChangeNickname() {
        let newNickname = nicknameTextField.textField.text
        // 닉네임 변경 로직 추가
        // 예: viewModel.updateNickname(newNickname)
        view.subviews.last?.removeFromSuperview()
        view.subviews.last?.removeFromSuperview()
    }
    
    @objc private func handleCloseButton() {
        view.subviews.last?.removeFromSuperview()
        view.subviews.last?.removeFromSuperview()
    }
}


import SwiftUI

struct AccountViewControllerPreview: UIViewControllerRepresentable {

func makeUIViewController(context: Context) -> AccountViewController {

return AccountViewController()

}

func updateUIViewController(_ uiViewController: AccountViewController, context: Context) {

}

}

#if DEBUG

struct AccountViewControllerPreview_Previews: PreviewProvider {

static var previews: some View {

AccountViewControllerPreview()

.previewDevice("iPhone 12")

}

}

#endif
