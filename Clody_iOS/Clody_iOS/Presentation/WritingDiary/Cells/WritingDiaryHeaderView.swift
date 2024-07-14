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
    }
    
    func setHierarchy() {
        
        self.addSubview(dateLabel)
    }
    
    func setLayout() {
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
        }
    }
    
    func bindData(date: String) {
        dateLabel.text = date
    }
}
