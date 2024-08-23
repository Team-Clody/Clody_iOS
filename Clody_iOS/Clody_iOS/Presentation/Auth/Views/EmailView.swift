//
//  EmailView.swift
//  Clody_iOS
//
//  Created by 김나연 on 8/12/24.
//

import UIKit

import SnapKit
import Then

final class EmailView: BaseView {
    
    // MARK: - UI Components
    
    let navigationBar = ClodyNavigationBar(type: .normal)
    private let introLabel = UILabel()
    let textField = ClodyTextField(type: .email)
    let nextButton = ClodyBottomButton(title: I18N.Common.next)
    
    // MARK: - Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        introLabel.do {
            $0.textColor = .grey01
            $0.attributedText = UIFont.pretendardString(
                text: I18N.Auth.emailIntro,
                style: .head1,
                lineHeightMultiple: 1.5
            )
            $0.numberOfLines = 0
        }
        
        nextButton.do {
            $0.isEnabled = false
            $0.backgroundColor = .lightYellow
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(navigationBar, introLabel, textField, nextButton)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(44))
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        introLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(ScreenUtils.getHeight(ScreenUtils.getWidth(40)))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(24))
        }
        
        textField.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(51))
            $0.top.equalTo(introLabel.snp.bottom).offset(ScreenUtils.getHeight(ScreenUtils.getWidth(40)))
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(48))
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(ScreenUtils.getHeight(5))
        }
    }
}
