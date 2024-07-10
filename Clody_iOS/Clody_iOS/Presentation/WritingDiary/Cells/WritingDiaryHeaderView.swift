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
    private let helpButton = UIButton()
    private let helpContainer = UIImageView()
    private let cancelButton = UIButton()
    private let helpLabel  = UILabel()
    
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
        
        dateLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "6월 26일 목요일", style: .head2, lineHeightMultiple: 1.5)
            $0.textColor = .grey02
        }
        
        helpButton.do {
            $0.setImage(.info, for: .normal)
         }
        
        helpContainer.do {
            $0.image = .helpMessage
            $0.contentMode = .scaleAspectFit
        }
        
        cancelButton.do {
            $0.setImage(.cancel, for: .normal)
        }
        
        helpLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "신조어, 비속어, 이모지 작성은 불가능해요", style: .detail1_medium, lineHeightMultiple: 1.5)
            $0.textColor = .blueCustom
        }
    }
    
    func setHierarchy() {
        
        self.addSubviews(
            dateLabel,
            helpButton,
            helpContainer,
            cancelButton,
            helpLabel
        )
    }
    
    func setLayout() {
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        helpButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.size.equalTo(28)
            $0.centerY.equalTo(dateLabel)
        }
        
        helpContainer.snp.makeConstraints {
            $0.bottom.equalTo(helpButton.snp.top)
            $0.trailing.equalTo(helpButton)
            $0.width.equalTo(228)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.trailing.equalTo(helpContainer)
            $0.size.equalTo(28)
        }
        
        helpLabel.snp.makeConstraints {
            $0.top.equalTo(helpContainer.snp.top).offset(9)
            $0.leading.equalTo(helpContainer.snp.leading).offset(8)
        }
    }
}

