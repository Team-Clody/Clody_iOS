//
//  ClodyAlert.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/9/24.
//

import UIKit

import SnapKit
import Then

enum AlertType {
    case logout
    case withdraw
    case deleteDiary
    case saveDiary
}

final class ClodyAlert: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    let leftButton = UIButton()
    let rightButton = UIButton()
    
    // MARK: - Properties
    
    var type: AlertType
    
    // MARK: - Life Cycles

    init(
        type: AlertType,
        title: String,
        message: String,
        rightButtonText: String
    ) {
        self.type = type
        super.init(frame: .zero)
        
        setStyle(with: title, message, rightButtonText)
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension ClodyAlert {
    
    // MARK: - Methods
    
    private func setStyle(
        with title: String,
        _ message: String,
        _ rightButtonText: String
    ) {
        backgroundColor = .white
        makeCornerRound(radius: 12)
        
        switch type {
        case .logout, .saveDiary:
            rightButton.backgroundColor = .mainYellow
            rightButton.setTitleColor(.grey01, for: .normal)
        case .withdraw, .deleteDiary:
            rightButton.backgroundColor = .redCustom
            rightButton.setTitleColor(.white, for: .normal)
        }
        
        titleLabel.do {
            $0.textColor = .grey01
            $0.attributedText = UIFont.pretendardString(text: title, style: .body1_semibold)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        messageLabel.do {
            $0.textColor = .grey04
            $0.attributedText = UIFont.pretendardString(
                text: message,
                style: .body3_regular,
                lineHeightMultiple: 1.5
            )
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        leftButton.do {
            $0.backgroundColor = .grey07
            $0.setTitleColor(.grey04, for: .normal)
            $0.setAttributedTitle(UIFont.pretendardString(text: I18N.Alert.cancel, style: .body3_semibold), for: .normal)
            $0.makeCornerRound(radius: 8)
        }
        
        rightButton.do {
            $0.setAttributedTitle(UIFont.pretendardString(text: rightButtonText, style: .body3_semibold), for: .normal)
            $0.makeCornerRound(radius: 8)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel, messageLabel, leftButton, rightButton)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(20))
            $0.horizontalEdges.greaterThanOrEqualToSuperview().inset(ScreenUtils.getWidth(20))
            $0.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.horizontalEdges.greaterThanOrEqualToSuperview().inset(ScreenUtils.getWidth(58))
            $0.centerX.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.width.equalTo(rightButton)
            $0.height.equalTo(ScreenUtils.getHeight(42))
            $0.top.equalTo(messageLabel.snp.bottom).offset(ScreenUtils.getHeight(25))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(20))
            $0.bottom.equalToSuperview().inset(ScreenUtils.getHeight(20))
        }
        
        rightButton.snp.makeConstraints {
            $0.height.equalTo(leftButton)
            $0.leading.equalTo(leftButton.snp.trailing).offset(ScreenUtils.getWidth(9))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(20))
            $0.centerY.equalTo(leftButton)
        }
    }
}
