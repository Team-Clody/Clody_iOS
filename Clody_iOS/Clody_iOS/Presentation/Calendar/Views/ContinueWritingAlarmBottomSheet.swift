//
//  ContinueWritingAlarmBottomSheet.swift
//  Clody_iOS
//
//  Created by 김나연 on 6/3/25.
//

import UIKit

import SnapKit
import Then

final class ContinueWritingAlarmBottomSheet: BaseView, BottomSheet {
    
    private let dimmedView = UIView()
    let bottomSheetView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let settingPathLabel = UILabel()
    let enableNotificationButton = UIButton()
    let skipForNowButton = UIButton()
    
    override func setStyle() {
        dimmedView.do {
            $0.alpha = 0
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
        
        bottomSheetView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.textColor = .grey01
            $0.attributedText = UIFont.pretendardString(
                text: I18N.BottomSheet.ContinueWriting.title,
                style: .head3,
                lineHeightMultiple: 1.5
            )
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        subtitleLabel.do {
            $0.textColor = .grey04
            $0.attributedText = UIFont.pretendardString(
                text: I18N.BottomSheet.ContinueWriting.subtitle,
                style: .body3_regular,
                lineHeightMultiple: 1.5
            )
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        settingPathLabel.do {
            $0.textColor = .grey04
            $0.attributedText = UIFont.pretendardString(
                text: I18N.BottomSheet.ContinueWriting.notificationSettingPath,
                style: .body3_regular,
                lineHeightMultiple: 1.5
            )
        }
        
        enableNotificationButton.do {
            $0.setAttributedTitle(
                UIFont.pretendardString(
                    text: I18N.BottomSheet.ContinueWriting.enableNotification,
                    style: .body2_semibold,
                    color: .grey01
                ),
                for: .normal
            )
            $0.backgroundColor = .mainYellow
            $0.makeCornerRound(radius: 10)
        }
        
        skipForNowButton.do {
            $0.setAttributedTitle(
                UIFont.pretendardString(
                    text: I18N.BottomSheet.ContinueWriting.skipForNow,
                    style: .body4_medium,
                    color: .grey05
                ),
                for: .normal
            )
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(dimmedView, bottomSheetView)
        bottomSheetView.addSubviews(titleLabel, subtitleLabel, settingPathLabel, enableNotificationButton, skipForNowButton)
    }
    
    override func setLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(20))
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(ScreenUtils.getHeight(10))
            $0.centerX.equalToSuperview()
        }
        
        settingPathLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(ScreenUtils.getHeight(4))
            $0.centerX.equalToSuperview()
        }
        
        enableNotificationButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(48))
            $0.top.equalTo(settingPathLabel.snp.bottom).offset(ScreenUtils.getHeight(28))
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
        }
        
        skipForNowButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(40))
            $0.top.equalTo(enableNotificationButton.snp.bottom)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
    }
    
    func animateShow() {
        dimmedView.alpha = 0.0
        bottomSheetView.transform = CGAffineTransform(translationX: 0, y: self.bottomSheetView.frame.height)
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 1.0
            self.bottomSheetView.transform = .identity
        }
    }
    
    func animateHide(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmedView.alpha = 0.0
            self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: self.bottomSheetView.frame.height)
        }) { _ in
            completion()
        }
    }
}
