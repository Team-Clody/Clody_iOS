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
    
    let stackView = UIStackView()
    let alertImage = UIImageView()
    let textLabel = UILabel()
    
    // MARK: - Properties
    
    var titleText = ""
    
    override func setStyle() {
        backgroundColor = .grey04
        makeCornerRound(radius: ScreenUtils.getHeight(42)/2)
            
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
            $0.spacing = ScreenUtils.getWidth(10)
            $0.alignment = .center
            $0.distribution = .fill
        }
    }
    
    override func setHierarchy() {
        self.addSubview(stackView)
        [alertImage, textLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(18))
            $0.centerY.equalToSuperview()
        }
        
        alertImage.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(18))
        }
    }
    
    private func updateConstraint() {
        self.snp.remakeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(42))
            $0.width.equalTo(textLabel.frame.width + ScreenUtils.getWidth(10) + ScreenUtils.getWidth(18)*3)
        }
    }
    
    func bindData(toastType: ToastType) {
        textLabel.attributedText = UIFont.pretendardString(text: toastType.message, style: .body4_semibold)
        textLabel.sizeToFit()
        updateConstraint()
        layoutIfNeeded()
    }
}
