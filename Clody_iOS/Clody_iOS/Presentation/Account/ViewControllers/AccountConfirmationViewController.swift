import UIKit

import RxSwift
import Then

final class AccountConfirmationViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = AccountConfirmationViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let rootView = AccountConfirmationView()
    
    // MARK: - Life Cycles
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAddTarget()
    }
    
    // MARK: - Setup
    private func setUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    private func setAddTarget() {
        rootView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc
    private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func confirmButtonTapped() {
        // Handle the logout action here
        dismiss(animated: true, completion: nil)
    }
}
