//
//  ClodyErrorRetryView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 8/14/24.
//

import UIKit

import SnapKit
import Then

final class ClodyErrorRetryView: BaseView {
    
    // MARK: - UI Components
    
    let errorImage = UIImageView()
    let titleLabel = UILabel()
    lazy var retryButton = UIButton()
    
    override func setStyle() {
                
        errorImage.do {
            $0.image = .errorRetry
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
        
        retryButton.do {
            $0.backgroundColor = .mainYellow
            $0.makeCornerRound(radius: 10)
            $0.setTitleColor(.grey02, for: .normal)
            let attributedTitle = UIFont.pretendardString(text: "다시 시도", style: .body2_semibold)
            $0.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(errorImage, titleLabel, retryButton)
    }
    
    override func setLayout() {
        errorImage.snp.makeConstraints {
            $0.width.equalTo(118)
            $0.height.equalTo(87)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).inset(232)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(errorImage.snp.bottom).offset(30)
        }
        
        retryButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(5)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    @objc func confirmButtonTapped() {
        self.removeFromSuperview()
    }
}

