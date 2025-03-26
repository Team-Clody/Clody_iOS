//
//  NotificationView.swift
//  Clody_iOS
//
//  Created by 김나연 on 3/25/25.
//

import UIKit

import SnapKit
import Then

final class NotificationView: BaseView {

    let navigationBar = ClodyNavigationBar(type: .setting, title: I18N.Setting.alarmSet)
    let tableView = UITableView()

    override func setStyle() {
        backgroundColor = .white
        
        tableView.do {
            $0.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.identifier)
            $0.sectionHeaderTopPadding = 0
            $0.separatorStyle = .none
        }
    }

    override func setHierarchy() {
        addSubviews(navigationBar, tableView)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(44))
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(ScreenUtils.getHeight(31-17.5))
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
