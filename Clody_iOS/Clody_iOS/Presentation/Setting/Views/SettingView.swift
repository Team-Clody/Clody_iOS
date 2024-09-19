//
//  SettingView.swift
//  Clody_iOS
//
//  Created by 김나연 on 9/19/24.
//

import UIKit

import SnapKit
import Then

final class SettingView: BaseView {
    
    let navigationBar = ClodyNavigationBar(type: .setting, title: I18N.Setting.setting)
    let tableView = UITableView()
    
    override func setStyle() {
        backgroundColor = .white
        
        tableView.do {
            $0.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
            $0.separatorStyle = .none
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(navigationBar, tableView)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(44))
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(ScreenUtils.getHeight(30-17.5))
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
