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
    
    private let navigationBar = ClodyNavigationBar(type: .normal)
    lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    let nextButton = UIButton()
    
    // MARK: - Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        nextButton.do {
            $0.setTitleColor(.grey01, for: .normal)
            $0.setTitleColor(.grey06, for: .disabled)
            $0.setAttributedTitle(UIFont.pretendardString(text: I18N.Common.next, style: .body2_semibold), for: .normal)
            $0.backgroundColor = .mainYellow
            $0.makeCornerRound(radius: 10)
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(navigationBar, pageViewController.view, nextButton)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(575))
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(5)
        }
    }
}
