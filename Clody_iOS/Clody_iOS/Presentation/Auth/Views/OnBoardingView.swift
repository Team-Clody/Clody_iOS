//
//  OnBoardingView.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/12/24.
//

import UIKit

import SnapKit
import Then

final class OnBoardingView: BaseView {
    
    // MARK: - UI Components
    
    lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    let pageControl = UIPageControl()
    let nextButton = UIButton()
    
    // MARK: - Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        pageControl.do {
            $0.currentPage = 0
            $0.numberOfPages = OnBoardingType.allCases.count
            $0.pageIndicatorTintColor = .grey07
            $0.currentPageIndicatorTintColor = .grey03
        }
        
        nextButton.do {
            $0.setTitleColor(.grey01, for: .normal)
            $0.setTitleColor(.grey06, for: .disabled)
            $0.setAttributedTitle(UIFont.pretendardString(text: I18N.Common.next, style: .body2_semibold), for: .normal)
            $0.backgroundColor = .mainYellow
            $0.makeCornerRound(radius: 10)
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(pageViewController.view, pageControl, nextButton)
    }
    
    override func setLayout() {
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(pageControl.snp.top)
        }
        
        pageControl.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-ScreenUtils.getHeight(48))
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(5)
        }
    }
}
