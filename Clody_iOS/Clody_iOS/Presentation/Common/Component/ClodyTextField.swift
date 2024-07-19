//
//  ClodyTextField.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/9/24.
//

import UIKit

import SnapKit
import Then

enum TextFieldType {
    case nickname
    case email
}

final class ClodyTextField: UIView {
    
    // MARK: - UI Components
    
    let textField = UITextField()
    private let underline = UIView()
    
    private lazy var messageLabel = UILabel()
        .then {
            $0.textColor = .grey04
            $0.attributedText = UIFont.pretendardString(
                text: type == .nickname ? I18N.Common.nicknameCondition : "",
                style: .detail1_regular
            )
        }
        .then {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(underline.snp.bottom).offset(6)
            }
        }
    
    public lazy var countLabel = UILabel()
        .then {
            $0.textColor = .grey04
            $0.attributedText = UIFont.pretendardString(text: "\(count)", style: .detail1_medium)
        }
        .then {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.trailing.equalTo(charLimitLabel.snp.leading).offset(-3)
                $0.centerY.equalTo(charLimitLabel)
            }
        }
    
    private lazy var charLimitLabel = UILabel()
        .then {
            $0.textColor = .grey06
            $0.attributedText = UIFont.pretendardString(text: I18N.Common.charLimit, style: .detail1_medium)
        }
        .then {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(underline.snp.bottom).offset(4)
                $0.trailing.equalToSuperview().inset(2)
            }
        }
    
    // MARK: - Properties
    
    let type: TextFieldType
    private var includedComponents: [UIView] = []
    private var errorMessage: String? {
        didSet {
            messageLabel.text = errorMessage
            underline.backgroundColor  = .red
            messageLabel.textColor = .red
        }
    }
    var count: Int = 0 {
        didSet {
            countLabel.attributedText = UIFont.pretendardString(text: "\(count)", style: .detail1_medium)
        }
    }
    
    // MARK: - Life Cycles
    
    init(type: TextFieldType) {
        self.type = type
        super.init(frame: .zero)
        
        setStyle()
        setHierarchy()
        setLayout()
        
        switch type {
        case .nickname:
            includedComponents = [textField, underline, messageLabel, countLabel, charLimitLabel]
        case .email:
            includedComponents = [textField, underline]
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension ClodyTextField {
    
    // MARK: - Methods
    
    private func setStyle() {
        textField.do {
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.backgroundColor = .clear
            $0.font = .pretendard(.body1_medium)
            $0.textColor = .grey03
            $0.clearButtonMode = .always
            $0.attributedPlaceholder = NSAttributedString(
                string: type == .nickname ? I18N.Common.enterNickname : I18N.Common.enterEmail,
                attributes: [NSAttributedString.Key.foregroundColor : UIColor.grey05]
            )
        }
        
        underline.do {
            $0.backgroundColor = .grey07
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(textField, underline)
    }
    
    private func setLayout() {
        textField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        underline.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.top.equalTo(textField.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(textField.snp.horizontalEdges)
        }
    }
    
    func showErrorMessage(_ message: String) {
        if type == .email {
            self.includedComponents.append(messageLabel)
        }
        
        self.errorMessage = message
    }
    
    func setFocusState(to isFocused: Bool) {
        underline.backgroundColor = isFocused ? .mainYellow : .grey07
    }
}
