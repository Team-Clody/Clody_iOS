import UIKit

import SnapKit
import Then

final class AccountView: UIView {

    // MARK: - UI Components
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let changeProfileButton = UIButton()
    let emailImageView = UIImageView()
    let emailLabel = UILabel()
    let logoutButton = UIButton()
    let deleteAccountButton = UIButton()
    let deleteConfirmationLabel = UILabel()
    let separatorLine = UIView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setUI() {
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
            $0.image = .profile
            $0.tintColor = .black
        }
        
        emailLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "clody@icloud.com", style: .body1_semibold)
            $0.textColor = .black
            $0.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(emailLabelTapped))
            $0.addGestureRecognizer(tapGesture)
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
            $0.backgroundColor = .grey07
        }

        
    }
    
    private func setHierarchy() {
        addSubviews(profileImageView, nicknameLabel, changeProfileButton, emailImageView, emailLabel, logoutButton, deleteAccountButton, deleteConfirmationLabel, separatorLine)
    }
    
    private func setConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(134)
            $0.left.equalToSuperview().offset(24)
            $0.width.height.equalTo(20)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.left.equalTo(profileImageView.snp.right).offset(10)
        }
        
        changeProfileButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.right.equalToSuperview().offset(-23)
        }

        emailImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.left.equalTo(profileImageView)
            $0.width.height.equalTo(20)
        }
        
        emailLabel.snp.makeConstraints {
            $0.centerY.equalTo(emailImageView)
            $0.left.equalTo(emailImageView.snp.right).offset(10)
        }
        
        logoutButton.snp.makeConstraints {
            $0.centerY.equalTo(emailLabel)
            $0.right.equalTo(changeProfileButton)
        }

        separatorLine.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(22)
            $0.width.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        deleteConfirmationLabel.snp.makeConstraints {
            $0.top.equalTo(separatorLine.snp.bottom).offset(22)
            $0.left.equalToSuperview().offset(26)
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.centerY.equalTo(deleteConfirmationLabel)
            $0.right.equalTo(logoutButton)
        }
    }
    
    // MARK: - Actions
    @objc private func emailLabelTapped() {
    }
}
