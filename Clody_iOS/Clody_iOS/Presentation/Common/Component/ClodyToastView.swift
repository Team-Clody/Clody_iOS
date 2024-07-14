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
            $0.attributedText = UIFont.pretendardString(text: "모든 감사 일기 작성이 필요해요.", style: .body4_semibold)
        }
    }
    
    override func setHierarchy() {
        self.addSubview(toastContainerView)
        
        toastContainerView.addSubviews(alertImage, textLabel)
    }
    
    override func setLayout() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(46))
        }
        
        toastContainerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(229))
        }
        
        alertImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(18))
            $0.size.equalTo(ScreenUtils.getWidth(18))
        }
        
        textLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(alertImage.snp.trailing).offset(ScreenUtils.getWidth(12))
        }
    }
    
    func bindData(message: String) {
        textLabel.text = message
    }
}

