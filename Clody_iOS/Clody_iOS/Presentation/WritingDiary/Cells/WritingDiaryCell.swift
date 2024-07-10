//
//  WritingDiaryCell.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class WritingDiaryCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    let listContainerView = UIView()
    private let listNumberLabel = UILabel()
    let diaryTextLabel = UILabel()
    
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
            $0.backgroundColor = .whiteCustom
        }
        
        listNumberLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "1.", style: .body2_semibold, lineHeightMultiple: 1.5)
            $0.textColor = .grey02
        }
        
        diaryTextLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "마지막이라 감사해. 정말~어쩌구, 2. 마지막이라 감사해. 정말~어쩌구,마지막이라 감사해. 정말~어쩌구, 마지막이라 감사해. 정말~어쩌구,", style: .body2_semibold, lineHeightMultiple: 1.5)
            $0.textColor = .grey03
            $0.numberOfLines = 0
        }
    }
    
    func setHierarchy() {
        
        self.addSubview(listContainerView)
        
        listContainerView.addSubviews(listNumberLabel, diaryTextLabel)
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
            $0.leading.equalToSuperview().inset(35)
            $0.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(listNumberLabel)
            $0.bottom.equalToSuperview()
        }
    }
    
    func bindData(diaryContent: String, index: Int) {
        listNumberLabel.text = "\(index + 1)."
        diaryTextLabel.text = diaryContent
    }
}

