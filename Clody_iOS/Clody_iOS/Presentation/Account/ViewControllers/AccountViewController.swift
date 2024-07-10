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
        setAddTarget()
    }
    
    // MARK: - Extensions
    private func bindViewModel() {
        viewModel.isLogoutButtonEnabled
            .bind(to: rootView.logoutButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    private func setAddTarget() {
        rootView.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        rootView.deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc
    func logoutButtonTapped() {
        print("dndn")
        let logoutVC = AccountConfirmationViewController()
        logoutVC.modalPresentationStyle = .overFullScreen
        present(logoutVC, animated: true, completion: nil)
    }

    @objc
    func deleteAccountButtonTapped() {
        print("ieie")
        let deleteAccountVC = AccountDeleteConfirmationViewController()
        deleteAccountVC.modalPresentationStyle = .overFullScreen
        present(deleteAccountVC, animated: true, completion: nil)
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
