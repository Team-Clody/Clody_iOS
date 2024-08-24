//
//  NotificationPickerView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import UIKit

import SnapKit
import Then

final class NotificationPickerView: BaseView {
    
    // MARK: - UI Components
    
    private let title: String
    
    // MARK: - UI Components
    
    let dimmedView = UIView()
    let backgroundView = UIView()
    let pickerView = ClodyPickerView(type: .notification)
    let closeButton = UIButton()
    private let titleLabel = UILabel()
    lazy var completeButton = UIButton()
    private let layoutGuide = UILayoutGuide()
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        titleLabel.do {
            $0.textColor = .grey01
            $0.attributedText = UIFont.pretendardString(text: title, style: .body2_semibold)
        }
        
        closeButton.do {
            $0.setImage(.icX, for: .normal)
        }
        
        completeButton.do {
            $0.backgroundColor = .mainYellow
            $0.makeCornerRound(radius: 10)
            $0.setTitleColor(.grey01, for: .normal)
            let attributedTitle = UIFont.pretendardString(text: "완료", style: .body2_semibold)
            $0.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
    
    override func setHierarchy() {
        self.addLayoutGuide(layoutGuide)
        self.addSubviews(dimmedView, backgroundView)
        backgroundView.addSubviews(
            pickerView,
            titleLabel,
            closeButton,
            completeButton
        )
    }
    
    override func setLayout() {
        layoutGuide.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(completeButton.snp.top)
        }
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(360)
        }
        
        pickerView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(completeButton)
            $0.center.equalTo(layoutGuide)
            $0.height.equalTo(223)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(14)
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(18)
            $0.size.equalTo(24)
        }
        
        completeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(5)
            $0.height.equalTo(48)
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

extension NotificationPickerView {
    
    func setTime(_ time: String) {
        pickerView.setTime(time)
    }
}
