import UIKit

import SnapKit
import Then

final class MyPageView: BaseView {
    
    let tableView = UITableView()
    let navigationBar = ClodyNavigationBar(type: .setting, title: "설정")
    
    override func setStyle() {
        tableView.do {
            $0.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identifier)
            $0.tableFooterView = UIView()
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 100
            $0.separatorStyle = .none
            $0.backgroundColor = .white
        }
        
        backgroundColor = UIColor(named: "whiteCustom")
    }
    
    override func setHierarchy() {
        addSubviews(navigationBar, tableView)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
