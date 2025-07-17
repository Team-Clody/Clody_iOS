//
//  ListCollectionViewCell.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class ListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    var cellDisposeBag = DisposeBag()
    
    let listContainerView = UIView()
    private let listNumberLabel = UILabel()
    let diaryTextLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellDisposeBag = DisposeBag()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStyle() {
        
        listContainerView.do {
            $0.backgroundColor = .white
        }
        
        listNumberLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "1.", style: .body2_semibold, applyLineHeight: true)
            $0.textColor = .grey01
        }
        
        diaryTextLabel.do {
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
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(20))
        }
        
        diaryTextLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(40))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(20))
            $0.top.equalTo(listNumberLabel)
            $0.bottom.equalToSuperview()
        }
    }
    
    func bindData(diaryContent: String, index: Int) {
        listNumberLabel.text = "\(index + 1)."
        diaryTextLabel.attributedText = UIFont.pretendardString(text: diaryContent, style: .body3_medium, color: .grey03, applyLineHeight: true)
    }
}
