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

    // MARK: - UI Components
    
    private let listContainerView = UIView()
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
            $0.backgroundColor = .grey08
            $0.layer.cornerRadius = 10
        }
        
        listNumberLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "1.", style: .body3_medium, lineHeightMultiple: 1.5)
            $0.textColor = .grey02
        }
        
        diaryTextLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "마지막이라 감사해. 정말~어쩌구, 2. 마지막이라 감사해. 정말~어쩌구,마지막이라 감사해. 정말~어쩌구, 마지막이라 감사해. 정말~어쩌구,", style: .body3_medium, lineHeightMultiple: 1.5)
            $0.textColor = .grey03
            $0.numberOfLines = 0
        }
    }
    
    func setHierarchy() {
        self.contentView.addSubview(listContainerView)
        
        listContainerView.addSubviews(listNumberLabel, diaryTextLabel)
    }
    
    func setLayout() {
        listContainerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        listNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(14))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(16))
        }
        listNumberLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        diaryTextLabel.snp.makeConstraints {
            $0.top.equalTo(listNumberLabel.snp.top)
            $0.leading.equalTo(listNumberLabel.snp.trailing).offset(ScreenUtils.getWidth(9))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(16))
            $0.bottom.equalToSuperview().inset(ScreenUtils.getHeight(14))
        }
    }

    func bindData(data: String, index: String) {
        listNumberLabel.text = index
        diaryTextLabel.text = data
    }
}
