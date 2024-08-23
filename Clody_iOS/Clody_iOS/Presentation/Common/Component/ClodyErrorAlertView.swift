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
    
    let dimmedView = UIView()
    let alertContainerView = UIView()
    let alertImage = UIImageView()
    let titleLabel = UILabel()
    lazy var errorConfirmButton = UIButton()
    
    override func setStyle() {
        
        dimmedView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.4)
        }
        
        alertContainerView.do {
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
            $0.textAlignment = .center
        }
        
        errorConfirmButton.do {
            $0.backgroundColor = .mainYellow
            $0.makeCornerRound(radius: 8)
            $0.setTitleColor(.grey02, for: .normal)
            let attributedTitle = UIFont.pretendardString(text: "확인", style: .body2_semibold)
            $0.setAttributedTitle(attributedTitle, for: .normal)
            $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(dimmedView)
        dimmedView.addSubview(alertContainerView)
        alertContainerView.addSubviews(alertImage, titleLabel, errorConfirmButton)
    }
    
    override func setLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alertContainerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(193)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        alertImage.snp.makeConstraints {
            $0.size.equalTo(38)
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(alertImage.snp.bottom).offset(6)
        }
        
        errorConfirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    @objc func confirmButtonTapped() {
        self.removeFromSuperview()
    }
}
