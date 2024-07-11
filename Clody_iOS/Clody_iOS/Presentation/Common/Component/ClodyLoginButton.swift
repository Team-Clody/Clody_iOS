//
//  ClodyLoginButton.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/11/24.
//

import UIKit

import SnapKit
import Then

enum LoginButtonType {
    case kakao
    case apple
}

final class ClodyLoginButton: UIButton {
    
    // MARK: - Properties
    
    private let type: LoginButtonType
    
    // MARK: - Life Cycles
    
    init(type: LoginButtonType) {
        self.type = type
        super.init(frame: .zero)
        
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ClodyLoginButton {
    
    func setStyle() {
        configuration = UIButton.Configuration.filled()
        configuration?.baseBackgroundColor = type == .apple ? .appleBlack : .kakaoYellow
        configuration?.baseForegroundColor = type == .apple ? .white : .grey01
        configuration?.background.cornerRadius = 10
        configuration?.image = type == .apple ? .icApple : .icKakao
        configuration?.imagePadding = 10
        configuration?.attributedTitle = AttributedString(
            UIFont.pretendardString(
                text: type == .apple ? I18N.Auth.appleLogin : I18N.Auth.kakaoLogin,
                style: .body2_semibold
            )
        )
    }
}
