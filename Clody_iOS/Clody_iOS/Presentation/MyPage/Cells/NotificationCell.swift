//
//  NotificationCell.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import UIKit

import SnapKit
import Then

final class NotificationCell: UITableViewCell {

    let titleLabel: UILabel = UILabel()
    let detailLabel: UILabel = UILabel()
    let arrowImageView: UIImageView = UIImageView()
    let switchControl: UISwitch = UISwitch()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        setStyle()
        setHierarchy()
        setLayout()
    }

    private func setStyle() {
        titleLabel.do {
            $0.textColor = .black
        }

        detailLabel.do {
            $0.font = UIFont.pretendard(.body3_medium)
            $0.textColor = .grey05
        }

        arrowImageView.do {
            $0.image = .arrow
            $0.contentMode = .scaleAspectFit
        }

        switchControl.do {
            $0.onTintColor = UIColor(named:"mainYellow")
        }
    }

    private func setHierarchy() {
        contentView.addSubviews(titleLabel, detailLabel, arrowImageView, switchControl)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(ScreenUtils.getHeight(24))
            $0.centerY.equalToSuperview()
        }

        detailLabel.snp.makeConstraints {
            $0.trailing.equalTo(arrowImageView.snp.leading)
            $0.centerY.equalToSuperview()
        }

        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(ScreenUtils.getHeight(14))
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(ScreenUtils.getHeight(25))
        }

        switchControl.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(ScreenUtils.getHeight(23))
            $0.centerY.equalToSuperview()
        }
    }

    func configure(with item: NotificationItem) {
        
        titleLabel.attributedText = UIFont.pretendardString(text: item.title, style: .body1_medium)
        
        if let detail = item.detail {
            detailLabel.attributedText = UIFont.pretendardString(text: detail, style: .body3_medium)
            detailLabel.isHidden = false
            arrowImageView.isHidden = false
            switchControl.isHidden = true
        } else {
            detailLabel.isHidden = true
            arrowImageView.isHidden = true
            switchControl.isHidden = false
        }
    }
}
