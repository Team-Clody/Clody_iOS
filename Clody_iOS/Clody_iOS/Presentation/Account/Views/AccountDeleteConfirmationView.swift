import UIKit

import SnapKit
import Then

final class AccountDeleteConfirmationView: UIView {
    
    // MARK: - UI Components
    let messageView = UIView()
    let messageLabel = UILabel()
    let subMessageLabel = UILabel()
    let cancelButton = UIButton()
    let confirmButton = UIButton()

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
        messageView.do {
            $0.backgroundColor = .whiteCustom
            $0.layer.cornerRadius = 12
        }
        
        messageLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "서비스를 탈퇴하시겠어요?", style: .body1_semibold)
            $0.textColor = .grey01
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        subMessageLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "작성하신 일기와 받은 답장 및 클로버가\n모두 삭제되며 복구할 수 없어요.", style: .body3_medium)
            $0.textColor = .grey04
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        cancelButton.do {
            let attributedTitle = UIFont.pretendardString(text: "취소", style: .body3_semibold)
            $0.setAttributedTitle(attributedTitle, for: .normal)
            $0.setTitleColor(.grey04, for: .normal)
            $0.backgroundColor = .grey07
            $0.layer.cornerRadius = 8
        }
        
        confirmButton.do {
            let attributedTitle = UIFont.pretendardString(text: "탈퇴할래요", style: .body3_semibold)
            $0.setAttributedTitle(attributedTitle, for: .normal)
            $0.setTitleColor(.whiteCustom, for: .normal)
            $0.backgroundColor = .redCustom
            $0.layer.cornerRadius = 8
        }
    }
    
    private func setHierarchy() {
        addSubview(messageView)
        messageView.addSubviews(messageLabel, subMessageLabel, cancelButton, confirmButton)
    }
    
    private func setConstraints() {
        messageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(327)
            $0.height.equalTo(197)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(27)
            $0.centerX.equalToSuperview()
        }
        
        subMessageLabel.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-23)
            $0.left.equalToSuperview().offset(20)
            $0.width.equalTo(139)
            $0.height.equalTo(42)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-23)
            $0.right.equalToSuperview().offset(-20)
            $0.width.equalTo(139)
            $0.height.equalTo(42)
        }
    }
}
