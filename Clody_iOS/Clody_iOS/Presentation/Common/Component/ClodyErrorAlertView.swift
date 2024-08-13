//
//  ClodyErrorAlertView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 8/13/24.
//

import UIKit

import SnapKit
import Then

final class ClodyErrorAlertView: BaseView {
    
    // MARK: - UI Components
    
    let alertContainerVIew = UIView()
    let alertImage = UIImageView()
    let titleLabel = UILabel()
    lazy var errorConfirmButton = UIButton()
    
    override func setStyle() {
        alertContainerVIew.do {
            $0.backgroundColor = .white
            $0.makeCornerRound(radius: 12)
        }
        
        alertImage.do {
            $0.image = .icInfo
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.textColor = .grey04
            $0.attributedText = UIFont.pretendardString(
                text: I18N.Error.unKnown,
                style: .body3_medium,
                lineHeightMultiple: 1.5
            )
            $0.numberOfLines = 2
        }
        
        errorConfirmButton.do {
            $0.backgroundColor = .mainYellow
            $0.makeCornerRound(radius: 8)
            $0.setTitleColor(.grey02, for: .normal)
            let attributedTitle = UIFont.pretendardString(text: "확인", style: .body2_semibold)
            $0.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
    
    override func setHierarchy() {
        self.addSubview(alertContainerVIew)
        alertContainerVIew.addSubviews(alertImage, titleLabel, errorConfirmButton)
    }
    
    override func setLayout() {
        alertContainerVIew.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(46))
            $0.쟝
        }
        
        alertImage.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(18))
        }
        
        errorConfirmButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
