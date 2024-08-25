import UIKit

import SnapKit
import Then

final class AccountView: BaseView {

    // MARK: - UI Components
    
    let navigationBar = ClodyNavigationBar(type: .setting, title: I18N.MyPage.profile)
    private let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let changeProfileButton = UIButton()
    private let emailImageView = UIImageView()
    let emailLabel = UILabel()
    let logoutButton = UIButton()
    let deleteAccountButton = UIButton()
    private let deleteConfirmationLabel = UILabel()
    private let separatorLine = UIView()
    let nicknameTextField = ClodyTextField(type: .nickname)
    
    // MARK: - Setup
    
    override func setStyle() {
        backgroundColor = .white
        
        profileImageView.do {
            $0.image = .clover
            $0.clipsToBounds = true
        }
        
        nicknameLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "로디님", style: .body1_semibold)
            $0.textColor = .black
        }
        
        changeProfileButton.do {
            let attributedTitle = UIFont.pretendardString(text: "변경하기", style: .body4_medium)
            $0.setAttributedTitle(attributedTitle, for: .normal)
            $0.setTitleColor(.grey05, for: .normal)
        }

        emailImageView.do {
            $0.tintColor = .black
        }
        
        emailLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "clody@icloud.com", style: .body1_semibold)
            $0.textColor = .black
        }
        
        logoutButton.do {
            let attributedTitle = UIFont.pretendardString(text: I18N.MyPage.logout, style: .body4_medium)
            $0.setAttributedTitle(attributedTitle, for: .normal)
            $0.setTitleColor(.grey05, for: .normal)
        }
        
        deleteAccountButton.do {
            let attributedTitle = UIFont.pretendardString(text: I18N.MyPage.revoke, style: .body4_medium)
            $0.setAttributedTitle(attributedTitle, for: .normal)
            $0.setTitleColor(.grey05, for: .normal)
        }
        
        deleteConfirmationLabel.do {
            $0.attributedText = UIFont.pretendardString(text: I18N.MyPage.delete, style: .body4_medium)
            $0.textColor = .grey05
        }
        
        separatorLine.do {
            $0.backgroundColor = .grey07
        }
        
        nicknameTextField.do {
            $0.isHidden = true
        }
    }
    
    override func setHierarchy() {
        addSubviews(navigationBar, profileImageView, nicknameLabel, changeProfileButton, emailImageView, emailLabel, logoutButton, deleteAccountButton, deleteConfirmationLabel, separatorLine, nicknameTextField)
    }
    
    override func setLayout() {
        
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(44))
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(ScreenUtils.getHeight(30))
            $0.left.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.width.height.equalTo(ScreenUtils.getWidth(20))
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.left.equalTo(profileImageView.snp.right).offset(ScreenUtils.getWidth(10))
        }
        
        changeProfileButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.right.equalToSuperview().inset(ScreenUtils.getWidth(23))
        }

        emailImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(ScreenUtils.getHeight(20))
            $0.left.equalTo(profileImageView)
            $0.width.height.equalTo(ScreenUtils.getWidth(20))
        }
        
        emailLabel.snp.makeConstraints {
            $0.centerY.equalTo(emailImageView)
            $0.left.equalTo(emailImageView.snp.right).offset(ScreenUtils.getWidth(10))
        }
        
        logoutButton.snp.makeConstraints {
            $0.centerY.equalTo(emailLabel)
            $0.right.equalTo(changeProfileButton)
        }

        separatorLine.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(ScreenUtils.getHeight(22))
            $0.width.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(8))
        }
        
        deleteConfirmationLabel.snp.makeConstraints {
            $0.top.equalTo(separatorLine.snp.bottom).offset(ScreenUtils.getHeight(22))
            $0.left.equalToSuperview().inset(ScreenUtils.getWidth(26))
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.centerY.equalTo(deleteConfirmationLabel)
            $0.right.equalTo(logoutButton)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(changeProfileButton.snp.bottom).offset(ScreenUtils.getHeight(20))
            $0.left.right.equalToSuperview()
        }
    }
    
}
