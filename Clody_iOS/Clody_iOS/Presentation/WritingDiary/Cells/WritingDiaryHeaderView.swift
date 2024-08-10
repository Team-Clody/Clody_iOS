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
    private let infoImage = UIImageView()
    private let helpMessageImage = UIImageView()
    private let helpMessageLabel = UILabel()
    private let cancelImage = UIImageView()
    
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
        
        infoImage.do {
            $0.image = .info
            $0.contentMode = .scaleAspectFit
        }
        
        helpMessageImage.do {
            $0.image = .helpMessage
            $0.contentMode = .scaleAspectFit
        }
        
        helpMessageLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "신조어, 비속어, 이모지 작성은 불가능해요", style: .detail1_medium, lineHeightMultiple: 1.5)
            $0.textColor = .blueCustom
        }
        
        cancelImage.do {
            $0.image = .cancel
            $0.contentMode = .scaleAspectFit
        }
    }
    
    func setHierarchy() {
        
        self.addSubviews(dateLabel, infoImage, helpMessageImage)
        helpMessageImage.addSubviews(helpMessageLabel, cancelImage)
    }
    
    func setLayout() {
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        infoImage.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.size.equalTo(28)
            $0.trailing.equalToSuperview()
        }
        
        helpMessageImage.snp.makeConstraints {
            $0.bottom.equalTo(infoImage.snp.top)
            $0.width.equalTo(228)
            $0.height.equalTo(36)
            $0.trailing.equalToSuperview()
        }
        
        helpMessageLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(8)
        }
        
        cancelImage.snp.makeConstraints {            
            $0.size.equalTo(28)
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
