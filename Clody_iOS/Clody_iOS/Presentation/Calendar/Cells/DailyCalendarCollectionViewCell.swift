//
//  DailyCalendarCollectionViewCell.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/4/24.
//

import UIKit

import SnapKit
import Then

final class DailyCalendarCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let listContainerView = UIView()
    private let listNumberLabel = UILabel()
    private let diaryTextLabel = UILabel()
    
    
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
        
        listContainerView.do {
            $0.backgroundColor = .grey08
            $0.layer.cornerRadius = 10
        }
        
        listNumberLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "1.", style: .body2_semibold)
            $0.textColor = .grey02
        }
        
        diaryTextLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "마지막 세미나에 참석할 수 있어 감사해", style: .body2_semibold)
            $0.textColor = .grey03
        }
    }
    
    func setHierarchy() {
        
        self.addSubviews(listContainerView, listNumberLabel, diaryTextLabel)
    }
    
    func setLayout() {
        
        listContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        listNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17)
            $0.leading.equalToSuperview().inset(16)
        }
        
        diaryTextLabel.snp.makeConstraints {
            $0.top.equalTo(listNumberLabel.snp.top)
            $0.leading.equalTo(listNumberLabel.snp.trailing).offset(9)
        }
    }
    
    func bindData(data: String) {
        diaryTextLabel.text = data
    }
}



