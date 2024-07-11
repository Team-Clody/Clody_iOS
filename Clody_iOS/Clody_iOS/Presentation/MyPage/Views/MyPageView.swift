import UIKit

import SnapKit
import Then

final class MyPageView: BaseView {
    
    let tableView = UITableView()
    
    override func setStyle() {
        tableView.do {
            $0.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identifier)
            $0.tableFooterView = UIView()
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 100
            $0.separatorStyle = .none
        }
        
        backgroundColor = UIColor(named: "whiteCustom")
    }
    
    override func setHierarchy() {
        addSubview(tableView)
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
