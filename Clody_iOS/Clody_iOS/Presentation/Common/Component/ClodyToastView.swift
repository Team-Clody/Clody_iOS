//
//  ClodyToastView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/14/24.
//

import UIKit

import SnapKit
import Then

final class ClodyToastView: BaseView {
    
    // MARK: - UI Components
    
    let toastContainerView = UIView()
    let alertImage = UIImageView()
    let textLabel = UILabel()
    var toastType = ToastType.needToWriteAll
    var titleText = ""
    let stackView = UIStackView()
    
    override func setStyle() {
        toastContainerView.do {
            $0.backgroundColor = .grey04
            $0.makeCornerRound(radius: 25)
        }
        
        alertImage.do {
            $0.image = .toastAlert
            $0.contentMode = .scaleAspectFit
        }
        
        textLabel.do {
            $0.textColor = .white
            $0.attributedText = UIFont.pretendardString(text: titleText, style: .body4_semibold)
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = ScreenUtils.getWidth(12)
            $0.alignment = .center
            $0.distribution = .fill
        }
    }
    
    override func setHierarchy() {
        self.addSubview(toastContainerView)
        toastContainerView.addSubview(stackView)
        stackView.addArrangedSubview(alertImage)
        stackView.addArrangedSubview(textLabel)
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(46))
        }
        
        toastContainerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        alertImage.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(18))
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func updateConstraint() {
        toastContainerView.snp.remakeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
            switch toastType {
            case .needToWriteAll:
                $0.width.equalTo(ScreenUtils.getWidth(229))
            case .limitFive:
                $0.width.equalTo(ScreenUtils.getWidth(250))
            case .alarm:
                $0.width.equalTo(ScreenUtils.getWidth(290))
            case .changeComplete:
                $0.width.equalTo(ScreenUtils.getWidth(162))
            case .notificationTimeChangeComplete:
                $0.width.equalTo(ScreenUtils.getWidth(213))
            }
        }
    }
    
    func bindData(toastType: ToastType) {
        self.toastType = toastType
        
        switch toastType {
        case .needToWriteAll:
            titleText = "모든 감사 일기 작성이 필요해요."
        case .limitFive:
            titleText = "일기는 5개까지만 작성할 수 있어요."
        case .alarm:
            titleText = "설정 > 알림 > 클로디에서 알림을 켜주세요."
        case .changeComplete:
            titleText = "변경을 완료했어요."
        case .notificationTimeChangeComplete:
            titleText = "알림 시간 설정을 완료했어요."
        }
        
        textLabel.attributedText = UIFont.pretendardString(text: titleText, style: .body4_semibold)
        
        updateConstraint()

        self.layoutIfNeeded()
    }
}
