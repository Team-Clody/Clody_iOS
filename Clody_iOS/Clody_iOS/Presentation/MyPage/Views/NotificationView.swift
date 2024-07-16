//
//  NotificationView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import UIKit

import SnapKit
import Then

final class NotificationView: BaseView {

    let tableView: UITableView = UITableView()
    public let navigationBar = ClodyNavigationBar(type: .setting, title: "알림 설정")

    override func setStyle() {
        tableView.do {
            $0.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
        }
    }

    override func setHierarchy() {
        addSubviews(navigationBar, tableView)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}