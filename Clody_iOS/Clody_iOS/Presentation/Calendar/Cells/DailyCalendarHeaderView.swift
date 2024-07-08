//
//  DailyCalendarHeaderCell.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/4/24.
//

import UIKit

import SnapKit
import Then

final class DailyCalendarHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let dateLabel = UILabel()
    private let dayLabel = UILabel()
    private lazy var kebabButton = UIButton()
    
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
        
        dateLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "6.26", style: .body1_medium)
            $0.textColor = .grey04
        }
        
        dayLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "목요일", style: .body1_medium)
            $0.textColor = .grey02
        }
        
        kebabButton.do {
            $0.setImage(.kebob, for: .normal)
        }
    }
    
    func setHierarchy() {
        
        self.addSubviews(dateLabel, dayLabel, kebabButton)
    }
    
    func setLayout() {
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(25)
        }
        
        dayLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(7)
        }
        
        kebabButton.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    func setDate(date: String) {
        dateLabel.text = date
    }
}
