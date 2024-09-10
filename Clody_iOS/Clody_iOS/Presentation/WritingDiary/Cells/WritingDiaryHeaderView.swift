//
//  WritingDiaryHeaderView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class WritingDiaryHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let dateLabel = UILabel()
    lazy var infoButton = UIButton()
    let helpMessageImage = UIImageView()
    private let helpMessageLabel = UILabel()
    let cancelHelpButton = UIButton()
    lazy var backButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setHierarchy()
        setLayout()
        cancelHelpButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

    }
    
    @objc func cancelButtonTapped() {
        print("Cancel button tapped")
    }

    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStyle() {
        self.backgroundColor = .clear
        
        backButton.do {
            $0.setImage(.icArrowLeft, for: .normal)
        }
        
        dateLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "6월 26일 목요일", style: .head2, lineHeightMultiple: 1.5)
            $0.textColor = .grey02
        }
        
        infoButton.do {
            $0.setImage(.info, for: .normal)
            $0.contentMode = .scaleAspectFit
        }
        
        helpMessageImage.do {
            $0.image = .helpMessage
            $0.isUserInteractionEnabled = true
            $0.bringSubviewToFront(cancelHelpButton)
            $0.contentMode = .scaleAspectFill
        }
        
        helpMessageLabel.do {
            $0.attributedText = UIFont.pretendardString(text: I18N.WritingDiary.helpMessage, style: .detail1_medium)
            $0.textColor = .blueCustom
        }
        
        cancelHelpButton.do {
            $0.setImage(.cancel, for: .normal)
        }
    }
    
    func setHierarchy() {
        self.addSubviews(dateLabel, infoButton, helpMessageImage, backButton)
        helpMessageImage.addSubviews(cancelHelpButton, helpMessageLabel)
    }
    
    func setLayout() {
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(30))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(12))
            $0.top.equalTo(safeAreaLayoutGuide).inset(ScreenUtils.getHeight(6))
        }

        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.top.equalTo(backButton.snp.bottom).offset(ScreenUtils.getHeight(14))
        }

        infoButton.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.size.equalTo(ScreenUtils.getWidth(28))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(24))
        }

        helpMessageImage.snp.makeConstraints {
            $0.bottom.equalTo(infoButton.snp.top)
            $0.width.equalTo(ScreenUtils.getWidth(228))
            $0.height.equalTo(ScreenUtils.getHeight(36))
            $0.trailing.equalTo(infoButton)
        }

        helpMessageLabel.snp.makeConstraints {
            $0.centerY.equalTo(cancelHelpButton)
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(8))
        }

        cancelHelpButton.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(28))
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }
    }

    func bindData(dateData: Date) {
        let month = DateFormatter.string(from: dateData, format: "M")
        let date = DateFormatter.string(from: dateData, format: "d")
        let dateString = DateFormatter.string(from: dateData, format: "yyyy-MM-dd")
        let dayOfContent = DateFormatter.date(from: dateString)
        
        dateLabel.text = month + "월 " + date + "일 " + (dayOfContent?.koreanDayOfWeek() ?? "")
    }
}
