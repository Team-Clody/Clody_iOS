import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class AccountViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = AccountViewModel()
    private let disposeBag = DisposeBag()
    
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
