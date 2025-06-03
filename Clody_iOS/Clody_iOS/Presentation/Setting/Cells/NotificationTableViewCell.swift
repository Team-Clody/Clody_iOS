//
//  NotificationTableViewCell.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

enum NotificationSettingType: CaseIterable {
    case diaryWriting
    case continueWriting
    case time
    case replyReceived

    var title: String {
        switch self {
        case .diaryWriting: return I18N.Notification.diaryWriting
        case .continueWriting: return I18N.Notification.continueWriting
        case .time: return I18N.Notification.time
        case .replyReceived: return I18N.Notification.replyReceived
        }
    }

    var hasToggle: Bool {
        return self != .time
    }
}

final class NotificationTableViewCell: UITableViewCell {
    
    static let identifier = "NotificationTableViewCell"
    
    // MARK: - UI Components
    
    let titleLabel = UILabel()
    lazy var timeSettingButton = UIButton()
    lazy var toggleSwitch = UISwitch()
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    private var type: NotificationSettingType? {
        didSet {
            if let type = type {
                setUI()
                titleLabel.attributedText = UIFont.pretendardString(
                    text: type.title,
                    style: .body1_medium
                )
            } else {
                timeSettingButton.removeFromSuperview()
                toggleSwitch.removeFromSuperview()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        type = nil
        disposeBag = DisposeBag()
    }
    
    // MARK: - Methods
    
    private func setUI() {
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    private func setStyle() {
        self.backgroundColor = .white
        
        titleLabel.do {
            $0.textColor = .grey03
        }
        
        if type == .time {
            timeSettingButton.do {
                $0.configuration = UIButton.Configuration.plain()
                $0.configuration?.baseForegroundColor = .grey05
                $0.configuration?.image = .icArrowRightGrey
                $0.configuration?.imagePadding = 0
                $0.configuration?.imagePlacement = .trailing
                $0.configuration?.contentInsets = .zero
            }
        } else {
            toggleSwitch.do {
                $0.onTintColor = .mainYellow
            }
        }
    }
    
    private func setHierarchy() {
        contentView.addSubviews(titleLabel, type == .time ? timeSettingButton : toggleSwitch)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.verticalEdges.equalToSuperview().inset(ScreenUtils.getHeight(17.5))
        }
        
        if type == .time {
            timeSettingButton.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(14))
                $0.centerY.equalToSuperview()
            }
        } else {
            toggleSwitch.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(24))
                $0.centerY.equalToSuperview()
            }
        }
    }
}

extension NotificationTableViewCell {
    
    func configure(type: NotificationSettingType, isOn: Bool? = nil, time: String? = nil) {
        self.type = type
        if let time = time {
            timeSettingButton.configuration?.attributedTitle = AttributedString(
                UIFont.pretendardString(
                    text: DateFormatter.convertTo12HourFormat(time),
                    style: .body3_medium
                )
            )
        }
        if let isOn = isOn {
            toggleSwitch.isOn = isOn
        }
    }
}
