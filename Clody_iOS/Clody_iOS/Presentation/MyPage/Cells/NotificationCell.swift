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
    lazy var detailLabel: UILabel = UILabel()
    lazy var arrowImageView: UIImageView = UIImageView()
    lazy var switchControl: UISwitch = UISwitch()
    var switchValueChanged: ((Bool) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        bindSwitch()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    private func bindSwitch() {
        switchControl.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }

    @objc private func switchChanged() {
        switchValueChanged?(switchControl.isOn)
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

    func configure(with item: AlarmModel, indexPath: Int) {
        titleLabel.attributedText = UIFont.pretendardString(
            text: SettingAlarmCellTitle.allCases[indexPath].rawValue,
            style: .body1_medium
        )
        
        switch indexPath {
        case 0:
            switchControl.isHidden = false
            switchControl.isOn = item.isDiaryAlarm
            detailLabel.isHidden = true
            arrowImageView.isHidden = true
        case 1:
            switchControl.isHidden = true
            detailLabel.isHidden = false
            arrowImageView.isHidden = false
            detailLabel.attributedText = UIFont.pretendardString(
                text: convertTo12HourFormat(item.time),
                style: .body3_medium
            )
        case 2:
            switchControl.isHidden = false
            switchControl.isOn = item.isReplyAlarm
            detailLabel.isHidden = true
            arrowImageView.isHidden = true
        default:
            return
        }
    }
    
    private func convertTo12HourFormat(_ time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let date = dateFormatter.date(from: time) else {
            return time
        }
        
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
}

enum SettingAlarmCellTitle: String, CaseIterable {
    case writingAlarm = "알기 작성 알림 받기"
    case time = "알림 시간"
    case replyAlarm = "답장 도착 알림 받기"
}
