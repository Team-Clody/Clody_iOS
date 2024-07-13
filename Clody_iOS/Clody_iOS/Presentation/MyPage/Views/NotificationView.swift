import UIKit

import SnapKit
import Then

final class NotificationView: BaseView {

    let tableView: UITableView = UITableView()

    override func setStyle() {
        tableView.do {
            $0.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
        }
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
