//
//  settingNicknameChangeView.swift
//  Clody_iOS
//
//  Created by 오서영 on 7/15/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class SettingNicknameChangeView: BaseView {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let dimmingView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.55)
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.attributedText = UIFont.pretendardString(text: "닉네임 변경", style: .body2_semibold)
        $0.textColor = .grey01
    }
    
    let nicknameTextField = ClodyTextField(type: .nickname)
    
    let changeButton = UIButton().then {
        let attributedTitle = UIFont.pretendardString(text: "변경하기", style: .body2_semibold)
        $0.setAttributedTitle(attributedTitle, for: .normal)
        $0.setTitleColor(.grey06, for: .normal)
        $0.backgroundColor = .lightYellow
        $0.layer.cornerRadius = 5
    }
    
    let closeButton = UIButton().then {
        $0.setTitle("x", for: .normal)
        $0.setTitleColor(.grey01, for: .normal)
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    
    override func setStyle() {
        nicknameTextField.textField.becomeFirstResponder()
    }
    
    override func setHierarchy() {
        addSubview(dimmingView)
        addSubview(containerView)
        
        containerView.addSubviews(titleLabel, nicknameTextField, changeButton, closeButton)
    }
    
    override func setLayout() {
        dimmingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(294)
            $0.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19)
            $0.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(81)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        
        changeButton.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(73)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.right.equalToSuperview().inset(22)
            $0.width.height.equalTo(24)
        }
    }
    
    // MARK: - Bind Actions
    
    func bindActions() {
        nicknameTextField.textField.rx.text.orEmpty
            .map { !$0.isEmpty }
            .subscribe(onNext: { [weak self] isValid in
                self?.changeButton.isEnabled = isValid
                self?.changeButton.backgroundColor = isValid ? .mainYellow : .lightYellow
                self?.changeButton.setTitleColor(isValid ? .grey01 : .grey06, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}
