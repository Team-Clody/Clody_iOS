import UIKit

import RxSwift
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
        
        bindViewModel()
        setStyle()
        setDelegate()
    }
}

// MARK: - Private Extension

private extension MyPageViewController {
    
    func bindViewModel() {
        rootView.navigationBar.backButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
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
        cell.selectionStyle = .none
        cell.configure(with: setting, at: indexPath)
        
        if indexPath.row == 0 || indexPath.row == 3 {
            cell.showSeparatorLine(true)
        } else {
            cell.showSeparatorLine(false)
        }
        
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
        switch setting {
        case .profile:
            self.navigationController?.pushViewController(AccountViewController(), animated: true)
        case .notification:
            self.navigationController?.pushViewController(NotificationViewController(), animated: true)
        default:
            return
        }
    }
}
