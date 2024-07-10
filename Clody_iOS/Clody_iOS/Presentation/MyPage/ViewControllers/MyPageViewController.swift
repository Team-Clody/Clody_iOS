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
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.items.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MyPageTableViewCell.identifier,
            for: indexPath
        ) as! MyPageTableViewCell
        let item = viewModel.items[indexPath.row]
        
        cell.textLabel?.text = item.text
        cell.textLabel?.font = UIFont.pretendard(.body1_medium)

        if item.text == "앱 버전" {
            let latestVersionLabel = UILabel().then {
                $0.text = item.detail
                $0.font = UIFont.pretendard(.body3_medium)
                $0.textColor = .grey05
            }

            cell.contentView.addSubview(latestVersionLabel)
            latestVersionLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().offset(-23)
            }
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        
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
