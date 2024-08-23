//
//  LoginView.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/11/24.
//

import UIKit

import SnapKit
import Then

final class LoginView: BaseView {
    
    // MARK: - UI Components
    
    private let symbolImageView = UIImageView()
    private let introImageView = UIImageView()
    private let clodyLogoImageView = UIImageView()
    let kakaoLoginButton = ClodyLoginButton(type: .kakao)
    let appleLoginButton = ClodyLoginButton(type: .apple)
    
    // MARK: - Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        symbolImageView.do {
            $0.image = .imgSymbol
            $0.contentMode = .scaleAspectFit
        }
        
        introImageView.do {
            $0.image = .imgSlogan
            $0.contentMode = .scaleAspectFit
        }
        
        clodyLogoImageView.do {
            $0.image = .imgWordmark
            $0.contentMode = .scaleAspectFit
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(symbolImageView, introImageView, clodyLogoImageView, kakaoLoginButton, appleLoginButton)
    }
    
    override func setLayout() {
        symbolImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(296))
            $0.centerX.equalToSuperview()
        }
        
        introImageView.snp.makeConstraints {
            $0.top.equalTo(symbolImageView.snp.bottom).offset(ScreenUtils.getHeight(21))
            $0.centerX.equalToSuperview()
        }
        
        clodyLogoImageView.snp.makeConstraints {
            $0.top.equalTo(introImageView.snp.bottom).offset(ScreenUtils.getHeight(11))
            $0.centerX.equalToSuperview()
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(48))
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(ScreenUtils.getHeight(-12))
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(48))
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(ScreenUtils.getHeight(43))
        }
    }
}
