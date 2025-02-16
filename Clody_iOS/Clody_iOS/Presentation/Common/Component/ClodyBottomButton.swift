//
//  ClodyBottomButton.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/9/24.
//

import UIKit

final class ClodyBottomButton: UIButton {
    
    // MARK: - Properties
    
    private var title: String
    private let isGreyButton: Bool
    
    // MARK: - Life Cycles
    
    init(title: String, isGreyButton: Bool = false) {
        self.title = title
        self.isGreyButton = isGreyButton
        super.init(frame: .zero)
        
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension ClodyBottomButton {
    
    // MARK: - Methods
    
    private func setStyle() {
        backgroundColor = isGreyButton ? .grey02 : .mainYellow
        makeCornerRound(radius: 10)
        setAttributedTitle(
            UIFont.pretendardString(
                text: title,
                style: .body2_semibold,
                color: isGreyButton ? .white : .grey01
            ),
            for: .normal
        )
        if !isGreyButton {
            setAttributedTitle(
                UIFont.pretendardString(
                    text: title,
                    style: .body2_semibold,
                    color: .grey06
                ),
                for: .disabled
            )
        }
    }
    
    /// Bool값에 따른 버튼 활성화, 비활성화 상태 지정 함수입니다.
    func setEnabledState(to status: Bool) {
        if isGreyButton == true { return }
        
        self.isEnabled = status
        self.backgroundColor = status ? .mainYellow : .lightYellow
    }
}
