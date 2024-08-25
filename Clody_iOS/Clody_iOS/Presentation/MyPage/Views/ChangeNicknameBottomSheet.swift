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

    let navigationBar = ClodyNavigationBar(type: .bottomSheet, title: I18N.MyPage.nickNameEdit)
    let clodyTextField = ClodyTextField(type: .nickname)
    let doneButton = ClodyBottomButton(title: I18N.MyPage.edit)

    // MARK: - Methods

    override func setStyle() {
        backgroundColor = .white
        makeCornerRound(radius: 16)
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        // TODO: placeholder 설정
    }
    
    override func setHierarchy() {
        self.addSubviews(navigationBar, clodyTextField, doneButton)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(60))
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }

        clodyTextField.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(51))
            $0.top.equalTo(navigationBar.snp.bottom).offset(ScreenUtils.getHeight(32))
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
        }

        doneButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(48))
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(ScreenUtils.getHeight(26))
        }
    }
}
