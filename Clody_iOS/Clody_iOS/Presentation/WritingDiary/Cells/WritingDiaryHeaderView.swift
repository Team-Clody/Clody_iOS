//
//  WritingDiaryHeaderView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class WritingDiaryHeaderView: UIView {
    
    // MARK: - UI Components
    
    private let dateLabel = UILabel()
    lazy var infoButton = UIButton()
    let helpMessageContainer = UIImageView()
    let helpMessageDownArrowImage = UIImageView()
    private let helpMessageLabel = UILabel()
    let cancelHelpButton = UIButton()
    lazy var backButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStyle() {
        self.backgroundColor = .clear
        
        backButton.do {
            $0.setImage(.icArrowLeft, for: .normal)
            $0.contentMode = .scaleAspectFit
        }
        
        dateLabel.do {
            $0.textColor = .grey01
        }
        
        infoButton.do {
            $0.setImage(.info, for: .normal)
            $0.contentMode = .scaleAspectFit
        }
        
        helpMessageContainer.do {
            $0.image = .helpBox
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = true
            $0.bringSubviewToFront(cancelHelpButton)
        }
        
        helpMessageDownArrowImage.do {
            $0.image = .helpDownArrow
        }
        
        helpMessageLabel.do {
            $0.attributedText = UIFont.pretendardString(text: I18N.WritingDiary.helpMessage, style: .detail1_medium)
            $0.textColor = .blueCustom
        }
        
        cancelHelpButton.do {
            $0.setImage(.cancel, for: .normal)
            $0.contentMode = .scaleAspectFit
        }
    }
    
    func setHierarchy() {
        self.addSubviews(dateLabel, helpMessageDownArrowImage, helpMessageContainer, infoButton, backButton)
        helpMessageContainer.addSubviews(helpMessageLabel, cancelHelpButton)
    }
    
    func setLayout() {
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(32))
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(6))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(12))
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(ScreenUtils.getHeight(14))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(24))
        }

        infoButton.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(28))
            $0.centerY.equalTo(dateLabel)
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.bottom.equalToSuperview()
        }

        helpMessageContainer.snp.makeConstraints {
            $0.bottom.equalTo(helpMessageDownArrowImage.snp.top).offset(ScreenUtils.getHeight(4))
        }
        
        helpMessageDownArrowImage.snp.makeConstraints {
            $0.bottom.equalTo(infoButton.snp.top).offset(ScreenUtils.getHeight(1.6))
            $0.centerX.equalTo(infoButton)
        }

        helpMessageLabel.snp.makeConstraints {
            $0.centerY.equalTo(cancelHelpButton)
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(8))
        }

        cancelHelpButton.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(28))
            $0.top.equalToSuperview()
            $0.leading.equalTo(helpMessageLabel.snp.trailing).offset(-3)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.centerX.equalTo(helpMessageDownArrowImage)
        }
    }

    func bindData(dateData: Date) {
        let month = DateFormatter.string(from: dateData, format: "M")
        let date = DateFormatter.string(from: dateData, format: "d")
        let dateString = DateFormatter.string(from: dateData, format: "yyyy-MM-dd")
        let dayOfContent = DateFormatter.date(from: dateString)
        
        let dateText = month + "월 " + date + "일 " + (dayOfContent?.koreanDayOfWeek() ?? "")
        dateLabel.attributedText = UIFont.pretendardString(text: dateText, style: .head2, lineHeightMultiple: 1.5)
    }
}
