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
    }
}
