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
            return .Onboarding.onboarding_1_title
        case .clover:
            return .Onboarding.onboarding_2_title
        case .today:
            return .Onboarding.onboarding_3_title
        case .write:
            return .Onboarding.onboarding_4_title
        }
    }
    
    var subTitle: String {
        switch self {
        case .intro:
            return .Onboarding.onboarding_1_sub
        case .clover:
            return .Onboarding.onboarding_2_sub
        case .today:
            return .Onboarding.onboarding_3_sub
        case .write:
            return .Onboarding.onboarding_4_sub
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
    
    // MARK: - Life Cycles
    
    init(type: OnBoardingType) {
        super.init(frame: .zero)
        
        titleLabel.attributedText = UIFont.pretendardString(
            text: type.title,
            style: .head1,
            applyLineHeight: true,
            align: .center
        )
        subTitleLabel.attributedText = UIFont.pretendardString(
            text: type.subTitle,
            style: .body1_medium,
            applyLineHeight: true,
            align: .center
        )
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
    }
    
    override func setLayout() {
        let isKorean = LocalizationConstant.languageCode == "ko"
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(ScreenUtils.getHeight(isKorean ? 113 : 76))
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(ScreenUtils.getHeight(isKorean ? 16 : 20))
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(ScreenUtils.getHeight(110))
        }
    }
}
