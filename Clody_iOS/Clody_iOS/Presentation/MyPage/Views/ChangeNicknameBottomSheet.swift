//
//  ChangeNicknameBottomSheet.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/19/24.
//

import UIKit

import SnapKit
import Then

final class ChangeNicknameBottomSheet: BaseView {

    // MARK: - UI Components

    let navigationBar = ClodyNavigationBar(type: .bottomSheet, title: "닉네임 변경")
    let textField = ClodyTextField(type: .nickname)
    let doneButton = ClodyBottomButton(title: "변경하기")

    // MARK: - Methods

    override func setStyle() {
        backgroundColor = .white
        makeCornerRound(radius: 16)
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        // TODO: placeholder 설정
    }
    
    override func setHierarchy() {
        self.addSubviews(navigationBar, textField, doneButton)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }

        textField.snp.makeConstraints {
            $0.height.equalTo(51)
            $0.top.equalTo(navigationBar.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        doneButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(26)
        }
    }
}
