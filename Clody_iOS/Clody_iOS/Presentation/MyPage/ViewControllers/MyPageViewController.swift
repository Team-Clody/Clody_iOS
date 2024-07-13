import UIKit

import RxCocoa
import RxSwift
import SnapKit
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
        setDelegate()
    }
}

// MARK: - Private Extension

private extension MyPageViewController {

    func bindViewModel() {
        let input = MyPageViewModel.Input()
        _ = viewModel.transform(from: input, disposeBag: disposeBag)
    }

    func setDelegate() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyPageViewModel.Setting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MyPageTableViewCell.identifier,
            for: indexPath
        ) as! MyPageTableViewCell
        
        let setting = MyPageViewModel.Setting.allCases[indexPath.row]
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
}
