//
//  DatePickerView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import UIKit

import SnapKit
import Then

final class DatePickerView: BaseView {
    
    // MARK: - UI Components
    
    let dimmedView = UIView()
    let backgroundView = UIView()
    let navigationBar = ClodyNavigationBar(type: .bottomSheet, title: I18N.Calendar.otherDay)
    let pickerView = ClodyPickerView(type: .calendar)
    lazy var completeButton = UIButton()
    
    override func setStyle() {
        dimmedView.do {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
        
        backgroundView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.clipsToBounds = true
        }
        
        completeButton.do {
            $0.backgroundColor = .mainYellow
            $0.makeCornerRound(radius: 10)
            $0.setTitleColor(.grey01, for: .normal)
            let attributedTitle = UIFont.pretendardString(text: I18N.Calendar.complete, style: .body2_semibold)
            $0.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(dimmedView, backgroundView)
        backgroundView.addSubviews(pickerView, navigationBar, completeButton)
    }
    
    override func setLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(52))
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        pickerView.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(223))
            $0.top.equalTo(navigationBar.snp.bottom).offset(ScreenUtils.getHeight(-7))
            $0.horizontalEdges.equalTo(completeButton)
            $0.bottom.equalTo(completeButton.snp.top).offset(ScreenUtils.getHeight(-8))
        }
        
        completeButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(48))
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(ScreenUtils.getHeight(5))
        }
    }

    func animateShow() {
        self.backgroundView.transform = CGAffineTransform(translationX: 0, y: self.backgroundView.frame.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmedView.alpha = 1.0
            self.backgroundView.transform = .identity
        })
    }
    
    func animateHide(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmedView.alpha = 0.0
            self.backgroundView.transform = CGAffineTransform(translationX: 0, y: self.backgroundView.frame.height)
        }, completion: { _ in
            completion()
        })
    }
}
