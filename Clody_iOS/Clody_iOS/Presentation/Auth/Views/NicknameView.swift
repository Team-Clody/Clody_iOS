//
//  NicknameView.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/12/24.
//

import UIKit

import SnapKit
import Then

final class NicknameView: BaseView {
    
    // MARK: - UI Components
    
    private let navigationBar = ClodyNavigationBar(type: .normal)
    private let introLabel = UILabel()
    let textField = ClodyTextField(type: .nickname)
    let completeButton = ClodyBottomButton(title: I18N.Common.complete)
    
    // MARK: - Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        introLabel.do {
            $0.textColor = .grey01
            $0.attributedText = UIFont.pretendardString(text: I18N.Auth.nickNameIntro, style: .head1)
            $0.numberOfLines = 0
        }
        
        completeButton.do {
            $0.isEnabled = false
            $0.setTitleColor(.grey01, for: .normal)
            $0.setTitleColor(.grey06, for: .disabled)
            $0.setAttributedTitle(UIFont.pretendardString(text: I18N.Common.complete, style: .body2_semibold), for: .normal)
            $0.backgroundColor = .lightYellow
            $0.makeCornerRound(radius: 10)
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(navigationBar, introLabel, textField, completeButton)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        introLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        
        textField.snp.makeConstraints {
            $0.height.equalTo(51)
            $0.top.equalTo(introLabel.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        completeButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(5)
        }
    }
}
