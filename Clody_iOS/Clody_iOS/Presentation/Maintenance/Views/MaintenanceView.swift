//
//  MaintenanceView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/13/25.
//

import UIKit

import SnapKit
import Then

final class MaintenanceView: BaseView {
    
    // MARK: - UI Components
    
    private let dimmedView = UIView()
    private let containerView = UIView()
    private let maintenanceImageView = UIImageView()
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    let confirmButton = UIButton()
    
    override func setStyle() {
        backgroundColor = .mainYellow
        
        dimmedView.do {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
        
        containerView.do {
            $0.backgroundColor = .white
            $0.makeCornerRound(radius: 12)
        }
        
        maintenanceImageView.do {
            $0.image = .maintenance
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.textColor = .grey03
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.attributedText = UIFont.pretendardString(
                text: "보다 안정적인 클로디 서비스를 위해\n시스템 점검 중이에요. 곧 다시 만나요!",
                style: .body3_medium,
                applyLineHeight: true
            )
        }
        
        timeLabel.do {
            $0.textColor = .grey04
            $0.attributedText = UIFont.pretendardString(
                text: "점검 중",
                style: .body3_medium
            )
        }
        
        confirmButton.do {
            $0.setTitleColor(.grey02, for: .normal)
            $0.backgroundColor = .mainYellow
            $0.makeCornerRound(radius: 8)
            let attributedTitle = UIFont.pretendardString(text: .Common.ok, style: .body3_semibold)
            $0.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(dimmedView, containerView)
        containerView.addSubviews(
            maintenanceImageView,
            titleLabel,
            timeLabel,
            confirmButton
        )
    }
    
    override func setLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(24))
        }
        
        maintenanceImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(20))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(175))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(maintenanceImageView.snp.bottom).offset(ScreenUtils.getHeight(20))
            $0.centerX.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(ScreenUtils.getHeight(6))
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(ScreenUtils.getHeight(25))
            $0.height.equalTo(ScreenUtils.getHeight(42))
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(20))
            $0.bottom.equalToSuperview().inset(ScreenUtils.getHeight(20))
        }
    }
    
    func configureContent(time: String) {
        let messaage = "점검 시간: " + time
        timeLabel.attributedText = UIFont.pretendardString(text: messaage, style: .body3_regular)
    }
}

