//
//  TermsView.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/11/24.
//

import UIKit

import SnapKit
import Then

final class TermsView: BaseView {
    
    // MARK: - UI Components
    
    private let navigationBar = ClodyNavigationBar(type: .normal)
    private let introLabel = UILabel()
    private let allAgreeTextButton = UIButton()
    private let allAgreeIconButton = UIButton()
    private let divider = UIView()
    private let requiredTermsLabel = UILabel()
    private let viewTermsDetailButton = UIButton()
    private let agreeTermsIconButton = UIButton()
    private let requiredPrivacyLabel = UILabel()
    private let viewPrivacyDetailButton = UIButton()
    private let agreePrivacyIconButton = UIButton()
    let nextButton = ClodyBottomButton(title: I18N.Common.next)
    
    // MARK: - Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        introLabel.do {
            $0.textColor = .grey01
            $0.attributedText = UIFont.pretendardString(
                text: I18N.Auth.termsIntro,
                style: .head1,
                lineHeightMultiple: 1.5
            )
            $0.numberOfLines = 0
        }
        
        allAgreeTextButton.do {
            $0.setAttributedTitle(UIFont.pretendardString(text: I18N.Auth.allAgree, style: .head3), for: .normal)
            $0.setTitleColor(.grey01, for: .normal)
        }
        
        allAgreeIconButton.do {
            $0.setImage(.icBigCheckWhite, for: .normal)
        }
        
        divider.do {
            $0.backgroundColor = .grey07
        }
        
        requiredTermsLabel.do {
            $0.attributedText = UIFont.pretendardString(text: I18N.Auth.required, style: .body1_medium)
            $0.textColor = .grey01
        }
        
        requiredPrivacyLabel.do {
            $0.attributedText = UIFont.pretendardString(text: I18N.Auth.required, style: .body1_medium)
            $0.textColor = .grey01
        }
        
        viewTermsDetailButton.do {
            $0.configuration = UIButton.Configuration.plain()
            $0.configuration?.baseForegroundColor = .grey01
            $0.configuration?.attributedTitle = AttributedString(
                UIFont.pretendardString(text: I18N.Auth.clodyTerms, style: .body1_medium)
            )
            $0.configuration?.image = .icArrowRight
            $0.configuration?.imagePlacement = .trailing
            $0.configuration?.contentInsets = .zero
        }
        
        viewPrivacyDetailButton.do {
            $0.configuration = UIButton.Configuration.plain()
            $0.configuration?.baseForegroundColor = .grey01
            $0.configuration?.attributedTitle = AttributedString(
                UIFont.pretendardString(text: I18N.Auth.privacy, style: .body1_medium)
            )
            $0.configuration?.image = .icArrowRight
            $0.configuration?.imagePlacement = .trailing
            $0.configuration?.contentInsets = .zero
        }
        
        agreeTermsIconButton.do {
            $0.setImage(.icSmallCheckWhite, for: .normal)
        }
        
        agreePrivacyIconButton.do {
            $0.setImage(.icSmallCheckWhite, for: .normal)
        }
        
        nextButton.do {
            $0.isEnabled = false
            $0.setTitleColor(.grey01, for: .normal)
            $0.setTitleColor(.grey06, for: .disabled)
            $0.setAttributedTitle(UIFont.pretendardString(text: I18N.Common.next, style: .body2_semibold), for: .normal)
            $0.backgroundColor = .lightYellow
            $0.makeCornerRound(radius: 10)
        }
    }
    
    override func setHierarchy() {
        addSubviews(navigationBar, introLabel, allAgreeTextButton, allAgreeIconButton, divider, requiredTermsLabel, viewTermsDetailButton, agreeTermsIconButton, requiredPrivacyLabel, viewPrivacyDetailButton, agreePrivacyIconButton, nextButton)
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
        
        allAgreeTextButton.snp.makeConstraints {
            $0.top.equalTo(introLabel.snp.bottom).offset(49)
            $0.leading.equalToSuperview().inset(24)
        }
        
        allAgreeIconButton.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalTo(allAgreeTextButton)
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(allAgreeTextButton.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        requiredTermsLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        
        viewTermsDetailButton.snp.makeConstraints {
            $0.leading.equalTo(requiredTermsLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(requiredTermsLabel)
        }
        
        agreeTermsIconButton.snp.makeConstraints {
            $0.size.equalTo(23)
            $0.trailing.equalToSuperview().inset(25)
            $0.centerY.equalTo(requiredTermsLabel)
        }
        
        requiredPrivacyLabel.snp.makeConstraints {
            $0.top.equalTo(requiredTermsLabel.snp.bottom).offset(20)
            $0.leading.equalTo(requiredTermsLabel)
        }
        
        viewPrivacyDetailButton.snp.makeConstraints {
            $0.leading.equalTo(requiredPrivacyLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(requiredPrivacyLabel)
        }
        
        agreePrivacyIconButton.snp.makeConstraints {
            $0.size.equalTo(23)
            $0.trailing.equalTo(agreeTermsIconButton)
            $0.centerY.equalTo(requiredPrivacyLabel)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(5)
        }
    }
}
