import UIKit

import SnapKit
import RxCocoa
import RxSwift
import Then

final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let rootView = MyPageView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setDelegate()
    }
}

// MARK: - Private Extension

private extension MyPageViewController {
    
    func setStyle() {
        view.backgroundColor = .white
        
        navigationController?.isNavigationBarHidden = true
    }
    
    func setDelegate() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        
        rootView.navigationBar.backButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDataSource

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Setting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MyPageTableViewCell.identifier,
            for: indexPath
        ) as! MyPageTableViewCell
        
        let setting = Setting.allCases[indexPath.row]
        cell.configure(with: setting, at: indexPath)
        
        if indexPath.row == 0 || indexPath.row == 3 {
            cell.showSeparatorLine(true)
        } else {
            cell.showSeparatorLine(false)
        }
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MyPageViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = Setting.allCases[indexPath.row]
        if setting == .profile {
            let accountViewController = AccountViewController()
            self.navigationController?.pushViewController(accountViewController, animated: true)
        } else if setting == .notification {
            let notificationViewController = NotificationViewController()
            self.navigationController?.pushViewController(notificationViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
