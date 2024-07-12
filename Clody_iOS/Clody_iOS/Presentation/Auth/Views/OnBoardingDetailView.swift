//
//  OnBoardingDetailViewController.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/12/24.
//

import UIKit

import SnapKit
import Then

enum OnBoardingType: CaseIterable {
    case intro
    case clover
    case today
    case write
    
    var title: String {
        switch self {
        case .intro:
            return I18N.Auth.onboarding_1_title
        case .clover:
            return I18N.Auth.onboarding_2_title
        case .today:
            return I18N.Auth.onboarding_3_title
        case .write:
            return I18N.Auth.onboarding_4_title
        }
    }
    
    var subTitle: String {
        switch self {
        case .intro:
            return I18N.Auth.onboarding_1_sub
        case .clover:
            return I18N.Auth.onboarding_2_sub
        case .today:
            return I18N.Auth.onboarding_3_sub
        case .write:
            return I18N.Auth.onboarding_4_sub
        }
    }
    
    var image: UIImage {
        switch self {
        case .intro:
            return .imgOnboarding1
        case .clover:
            return .imgOnboarding2
        case .today:
            return .imgOnboarding3
        case .write:
            return .imgOnboarding4
        }
    }
}

final class OnBoardingDetailView: BaseView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let imageView = UIImageView()
    private let layoutGuide = UILayoutGuide()
    
    // MARK: - Life Cycles
    
    init(type: OnBoardingType) {
        super.init(frame: .zero)
        
        titleLabel.attributedText = UIFont.pretendardString(text: type.title, style: .head1)
        subTitleLabel.attributedText = UIFont.pretendardString(text: type.subTitle, style: .body1_medium)
        imageView.image = type.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func setStyle() {
        titleLabel.do {
            $0.textColor = .grey01
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        subTitleLabel.do {
            $0.textColor = .grey05
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        imageView.do {
            $0.contentMode = .scaleAspectFit
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(titleLabel, subTitleLabel, imageView)
        self.addLayoutGuide(layoutGuide)
    }
    
    override func setLayout() {
        layoutGuide.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(113))
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(layoutGuide)
        }
    }
}
