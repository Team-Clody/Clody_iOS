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
    
    let navigationBar = ClodyNavigationBar(type: .normal)
    private let introLabel = UILabel()
    let allAgreeTextButton = UIButton()
    let allAgreeIconButton = UIButton()
    private let divider = UIView()
    private let requiredTermsLabel = UILabel()
    let viewTermsDetailButton = UIButton()
    let agreeTermsIconButton = UIButton()
    private let requiredPrivacyLabel = UILabel()
    let viewPrivacyDetailButton = UIButton()
    let agreePrivacyIconButton = UIButton()
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
            $0.setImage(.icBigCheckYellow, for: .selected)
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
            $0.setImage(.icSmallCheckYellow, for: .selected)
        }
        
        agreePrivacyIconButton.do {
            $0.setImage(.icSmallCheckWhite, for: .normal)
            $0.setImage(.icSmallCheckYellow, for: .selected)
        }
        
        nextButton.do {
            $0.isEnabled = false
            $0.backgroundColor = .lightYellow
        }
    }
    
    override func setHierarchy() {
        addSubviews(
            navigationBar,
            introLabel,
            allAgreeTextButton,
            allAgreeIconButton,
            divider,
            requiredTermsLabel,
            viewTermsDetailButton,
            agreeTermsIconButton,
            requiredPrivacyLabel,
            viewPrivacyDetailButton,
            agreePrivacyIconButton,
            nextButton
        )
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getWidth(44))
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        introLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(ScreenUtils.getHeight(40))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(24))
        }
        
        allAgreeTextButton.snp.makeConstraints {
            $0.top.equalTo(introLabel.snp.bottom).offset(ScreenUtils.getHeight(49))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(24))
        }
        
        allAgreeIconButton.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(25))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.centerY.equalTo(allAgreeTextButton)
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(1))
            $0.top.equalTo(allAgreeTextButton.snp.bottom).offset(ScreenUtils.getHeight(15))
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
        }
        
        requiredTermsLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(ScreenUtils.getHeight(16))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(24))
        }
        
        viewTermsDetailButton.snp.makeConstraints {
            $0.leading.equalTo(requiredTermsLabel.snp.trailing).offset(ScreenUtils.getWidth(8))
            $0.centerY.equalTo(requiredTermsLabel)
        }
        
        agreeTermsIconButton.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(23))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(25))
            $0.centerY.equalTo(requiredTermsLabel)
        }
        
        requiredPrivacyLabel.snp.makeConstraints {
            $0.top.equalTo(requiredTermsLabel.snp.bottom).offset(ScreenUtils.getHeight(20))
            $0.leading.equalTo(requiredTermsLabel)
        }
        
        viewPrivacyDetailButton.snp.makeConstraints {
            $0.leading.equalTo(requiredPrivacyLabel.snp.trailing).offset(ScreenUtils.getWidth(8))
            $0.centerY.equalTo(requiredPrivacyLabel)
        }
        
        agreePrivacyIconButton.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(23))
            $0.trailing.equalTo(agreeTermsIconButton)
            $0.centerY.equalTo(requiredPrivacyLabel)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(48))
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(ScreenUtils.getHeight(5))
        }
    }
}
