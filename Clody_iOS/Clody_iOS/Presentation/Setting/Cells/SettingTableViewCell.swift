//
//  SettingTableViewCell.swift
//  Clody_iOS
//
//  Created by 김나연 on 9/19/24.
//

import UIKit

import Then
import SnapKit

final class SettingTableViewCell: UITableViewCell {
    
    static let identifier = "SettingTableViewCell"
    
    // MARK: - Properties
    
    private var isAppVerisionCell = false
    
    // MARK: - UI Components
    
    private let title = UILabel()
    private var arrowRightImageView: UIImageView?
    private var appVersionLabel: UILabel?
    
    private func setStyle() {
        backgroundColor = .white
//        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
        contentView.layoutMargins = UIEdgeInsets.zero
        
        title.do {
            $0.textColor = .grey03
        }
        
        if isAppVerisionCell {
            appVersionLabel!.do {
                $0.textColor = .grey05
            }
        } else {
            arrowRightImageView!.do {
                $0.image = .icArrowRightGrey
                $0.contentMode = .scaleAspectFit
            }
        }
    }
    
    private func setHierarchy() {
        self.contentView.addSubviews(title, (isAppVerisionCell ? appVersionLabel : arrowRightImageView)!)
    }
    
    private func setLayout() {
        title.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.verticalEdges.equalToSuperview().inset(ScreenUtils.getHeight(17.5))
        }
        
        if isAppVerisionCell {
            appVersionLabel!.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(23))
                $0.centerY.equalToSuperview()
            }
        } else {
            arrowRightImageView!.snp.makeConstraints {
                $0.size.equalTo(ScreenUtils.getWidth(25))
                $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(14))
                $0.centerY.equalToSuperview()
            }
        }
    }
}

extension SettingTableViewCell {
    
    func configure(item: SettingList) {
        title.attributedText = UIFont.pretendardString(text: item.title, style: .body1_medium)
        
        if item.title == Section2.version.title {
            isAppVerisionCell = true
            appVersionLabel = UILabel()
            appVersionLabel!.attributedText = UIFont.pretendardString(text: I18N.Setting.newVersion, style: .body4_medium)
        } else {
            isAppVerisionCell = false
            arrowRightImageView = UIImageView()
        }
        
        setStyle()
        setHierarchy()
        setLayout()
    }
}
