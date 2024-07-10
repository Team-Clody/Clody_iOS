//
//  ClodyNavigationBar.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/9/24.
//

import UIKit

import SnapKit
import Then

enum NavigationBarType {
    case normal
    case calendar
    case list
    case setting, reply
    case bottomSheet
}

final class ClodyNavigationBar: UIView {
    
    // MARK: - UI Components

    lazy var backButton = UIButton()
        .then {
            $0.setImage(.icArrowLeft, for: .normal)
        }
        .then {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(30)
                $0.leading.equalToSuperview().inset(12)
                $0.centerY.equalToSuperview()
            }
        }
    
    lazy var listButton = UIButton()
        .then {
            $0.setImage(.icList, for: .normal)
        }
        .then {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(18)
                $0.centerY.equalToSuperview()
            }
        }
    
    lazy var calendarButton = UIButton()
        .then {
            $0.setImage(.icCalendar, for: .normal)
        }
        .then {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(18)
                $0.centerY.equalToSuperview()
            }
        }
    
    lazy var dateButton = UIButton()
        .then {
            $0.configuration = UIButton.Configuration.plain()
            $0.configuration?.baseForegroundColor = .grey01
            $0.configuration?.image = .icArrowDown
            $0.configuration?.imagePlacement = .trailing
        }
        .then {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    
    lazy var xButton = UIButton()
        .then {
            $0.setImage(.icX, for: .normal)
        }
        .then {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(18)
                $0.centerY.equalToSuperview()
            }
        }
    
    lazy var settingButton = UIButton()
        .then {
            $0.setImage(.icSetting, for: .normal)
        }
        .then {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(18)
                $0.centerY.equalToSuperview()
            }
        }
    
    private lazy var titleLabel = UILabel()
        .then {
            $0.textColor = .grey01
            $0.font = .pretendard(.head4)
            $0.textAlignment = .center
        }
        .then {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    
    // MARK: - Properties
    
    private let type: NavigationBarType
    private var includedComponents: [UIView] = []
    
    var titleText: String = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var dateText: String = "" {
        didSet {
            dateButton.configuration?.attributedTitle = AttributedString(
                UIFont.pretendardString(text: dateText, style: .head4)
            )
        }
    }
    
    // MARK: - Life Cycles
    
    init(type: NavigationBarType) {
        self.type = type
        super.init(frame: .zero)
        setStyle()
        
        switch type {
        case .normal:
            includedComponents = [backButton]
        case .calendar:
            includedComponents = [listButton, dateButton, settingButton]
        case .list:
            includedComponents = [calendarButton, dateButton]
        case .setting, .reply:
            includedComponents = [backButton, titleLabel]
        case .bottomSheet:
            includedComponents = [titleLabel, xButton]
        }
    }
    
    convenience init(type: NavigationBarType, date: String) {
        self.init(type: type)
        
        defer {
            self.dateText = date
        }
    }
    
    convenience init(type: NavigationBarType, title: String) {
        self.init(type: type)
        
        defer {
            self.titleText = title
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

private extension ClodyNavigationBar {
    
    // MARK: - Methods
    
    func setStyle() {
        self.backgroundColor = .white
        
        if type == .bottomSheet {
            titleLabel.font = .pretendard(.body1_semibold)
        }
    }
}
