//
//  DiaryNotificationView.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/12/24.
//

import UIKit

import SnapKit
import Then

final class DiaryNotificationView: BaseView {
    
    // MARK: - UI Components
    
    private let introLabel = UILabel()
    let timeSettingView = UIView()
    let timeLabel = UILabel()
    private let downButton = UIButton()
    private let divider = UIView()
    let completeButton = ClodyBottomButton(title: I18N.Common.complete)
    let setNextButton = UIButton()
    
    // MARK: - Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        introLabel.do {
            $0.textColor = .grey01
            $0.attributedText = UIFont.pretendardString(
                text: I18N.Auth.notificationIntro,
                style: .head1,
                lineHeightMultiple: 1.5
            )
            $0.numberOfLines = 0
        }
        
        timeLabel.do {
            $0.textColor = .grey03
            $0.attributedText = UIFont.pretendardString(text: "오후 9시 30분", style: .body1_semibold)
        }
        
        downButton.do {
            $0.setImage(.icArrowDown, for: .normal)
        }
        
        divider.do {
            $0.backgroundColor = .grey07
        }
        
        completeButton.do {
            $0.backgroundColor = .mainYellow
        }
        
        setNextButton.do {
            $0.setTitleColor(.grey05, for: .normal)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.pretendard(.detail1_medium),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            let attributedTitle = NSAttributedString(string: I18N.Auth.setNext, attributes: attributes)
            $0.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(introLabel, timeSettingView, completeButton, setNextButton)
        timeSettingView.addSubviews(timeLabel, downButton, divider)
    }
    
    override func setLayout() {
        introLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(ScreenUtils.getHeight(84))
            $0.leading.equalToSuperview().inset(24)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        downButton.snp.makeConstraints {
            $0.size.equalTo(23)
            $0.top.equalToSuperview().inset(0.5)
            $0.trailing.equalToSuperview()
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.top.equalTo(timeLabel.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        timeSettingView.snp.makeConstraints {
            $0.height.equalTo(27)
            $0.top.equalTo(introLabel.snp.bottom).offset(49)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        completeButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(setNextButton.snp.top).offset(-6)
        }
        
        setNextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
