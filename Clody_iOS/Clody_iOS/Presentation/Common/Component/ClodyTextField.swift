//
//  ClodyTextField.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/9/24.
//

import UIKit

import SnapKit
import Then

final class ClodyTextField: BaseView {
    
    // MARK: - UI Components
    
    let textField = UITextField()
    private let underline = UIView()
    private let messageLabel = UILabel()
    let countLabel = UILabel()
    private let charLimitLabel = UILabel()
    
    // MARK: - Properties
    
    private var errorMessage: String? {
        didSet {
            messageLabel.attributedText = UIFont.pretendardString(
                text: errorMessage!,
                style: .detail1_regular,
                color: .redCustom
            )
            underline.backgroundColor  = .redCustom
        }
    }
    var count: Int = 0 {
        didSet {
            countLabel.attributedText = UIFont.pretendardString(text: "\(count)", style: .detail1_medium)
        }
    }
    
    // MARK: - Methods
    
    override func setStyle() {
        textField.do {
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.backgroundColor = .clear
            $0.font = .pretendard(.body1_medium)
            $0.textColor = .grey03
            $0.clearButtonMode = .always
            $0.attributedPlaceholder = NSAttributedString(
                string: I18N.Common.enterNickname,
                attributes: [NSAttributedString.Key.foregroundColor : UIColor.grey05]
            )
        }
        
        underline.do {
            $0.backgroundColor = .grey08
        }
        
        messageLabel.do {
            $0.textColor = .grey04
            $0.attributedText = UIFont.pretendardString(
                text: I18N.Common.nicknameCondition,
                style: .detail1_regular
            )
        }
        
        countLabel.do {
            $0.textColor = .grey04
            $0.attributedText = UIFont.pretendardString(text: "\(count)", style: .detail1_medium)
        }
        
        charLimitLabel.do {
            $0.textColor = .grey06
            $0.attributedText = UIFont.pretendardString(text: I18N.Common.charLimit, style: .detail1_medium)
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(textField, underline, messageLabel, countLabel, charLimitLabel)
    }
    
    override func setLayout() {
        textField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        underline.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(2))
            $0.top.equalTo(textField.snp.bottom).offset(ScreenUtils.getHeight(4))
            $0.horizontalEdges.equalTo(textField.snp.horizontalEdges)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(underline.snp.bottom).offset(ScreenUtils.getHeight(3))
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(countLabel.snp.leading).offset(-ScreenUtils.getWidth(16))
            $0.bottom.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.trailing.equalTo(charLimitLabel.snp.leading).offset(-ScreenUtils.getWidth(3))
            $0.centerY.equalTo(charLimitLabel)
        }
        
        charLimitLabel.snp.makeConstraints {
            $0.top.equalTo(underline.snp.bottom).offset(ScreenUtils.getHeight(2))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(2))
        }
    }
}

// MARK: - Extensions

extension ClodyTextField {
    
    func showErrorMessage(_ message: String) {
        messageLabel.isHidden = false
        errorMessage = message
    }
    
    func hideErrorMessage() {
        underline.backgroundColor = .mainYellow
        
        messageLabel.do {
            $0.textColor = .grey04
            $0.attributedText = UIFont.pretendardString(
                text: I18N.Common.nicknameCondition,
                style: .detail1_regular
            )
        }
    }
    
    func setFocusState(to isFocused: Bool) {
        if underline.backgroundColor != UIColor.redCustom {
            underline.backgroundColor = isFocused ? .mainYellow : .grey08
        }
    }
}
