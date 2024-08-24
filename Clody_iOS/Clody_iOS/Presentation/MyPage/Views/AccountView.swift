import UIKit

import SnapKit
import Then

final class AccountView: BaseView {
    
    let navigationBar = ClodyNavigationBar(type: .setting, title: "프로필 및 계정 관리")
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    let changeProfileButton = UIButton()
    private let emailImageView = UIImageView()
    private let emailLabel = UILabel()
    let logoutButton = UIButton()
    let deleteAccountButton = UIButton()
    private let deleteConfirmationLabel = UILabel()
    private let separatorLine = UIView()
    
    var nickname = "" {
        didSet {
            nicknameLabel.do {
                $0.attributedText = UIFont.pretendardString(text: nickname, style: .body1_semibold)
                $0.textColor = .black
            }
        }
    }
    var email = "" {
        didSet {
            emailLabel.do {
                $0.attributedText = UIFont.pretendardString(text: email, style: .body1_semibold)
                $0.textColor = .black
            }
        }
    }
    var loginPlatform: LoginPlatformType = .apple {
        didSet {
            emailImageView.do {
                $0.image = (loginPlatform == .apple) ? .icAppleProfile : .icKakaoProfile
                $0.contentMode = .scaleAspectFit
            }
        }
    }
    
    override func setStyle() {
        backgroundColor = .white
        
        profileImageView.do {
            $0.image = .icClover
            $0.contentMode = .scaleAspectFit
        }
        
        changeProfileButton.do {
            let attributedTitle = UIFont.pretendardString(text: "변경하기", style: .body4_medium)
            $0.setAttributedTitle(attributedTitle, for: .normal)
            $0.setTitleColor(.grey05, for: .normal)
        }
        
        logoutButton.do {
            let attributedTitle = UIFont.pretendardString(text: "로그아웃", style: .body4_medium)
            $0.setAttributedTitle(attributedTitle, for: .normal)
            $0.setTitleColor(.grey05, for: .normal)
        }
        
        deleteAccountButton.do {
            let attributedTitle = UIFont.pretendardString(text: "회원탈퇴", style: .body4_medium)
            $0.setAttributedTitle(attributedTitle, for: .normal)
            $0.setTitleColor(.grey05, for: .normal)
        }
        
        deleteConfirmationLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "계정을 삭제하시겠어요?", style: .body4_medium)
            $0.textColor = .grey05
        }
        
        separatorLine.do {
            $0.backgroundColor = .grey08
        }
    }
    
    override func setHierarchy() {
        addSubviews(navigationBar, profileImageView, nicknameLabel, changeProfileButton, emailImageView, emailLabel, logoutButton, deleteAccountButton, deleteConfirmationLabel, separatorLine)
    }
    
    override func setLayout() {
        
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.top.equalTo(navigationBar.snp.bottom).offset(33)
            $0.leading.equalToSuperview().inset(24)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        changeProfileButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.trailing.equalToSuperview().inset(23)
        }

        emailImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.equalTo(profileImageView.snp.bottom).offset(36)
            $0.leading.equalTo(profileImageView)
        }
        
        emailLabel.snp.makeConstraints {
            $0.centerY.equalTo(emailImageView)
            $0.leading.equalTo(emailImageView.snp.trailing).offset(10)
        }
        
        logoutButton.snp.makeConstraints {
            $0.centerY.equalTo(emailImageView)
            $0.trailing.equalTo(changeProfileButton)
        }

        separatorLine.snp.makeConstraints {
            $0.height.equalTo(8)
            $0.width.equalToSuperview()
            $0.top.equalTo(emailLabel.snp.bottom).offset(22)
        }
        
        deleteConfirmationLabel.snp.makeConstraints {
            $0.top.equalTo(separatorLine.snp.bottom).offset(22)
            $0.leading.equalToSuperview().inset(26)
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.centerY.equalTo(deleteConfirmationLabel)
            $0.trailing.equalTo(logoutButton)
        }
    }
}
