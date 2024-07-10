//
//  ListHeaderView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class ListHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let cloverImageView = UIImageView()
    private let dateLabel = UILabel()
    private let dayLabel = UILabel()
    lazy var replyButton = UIButton()
    private let newImageView = UIImageView()
    lazy var kebabButton = UIButton()
    
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
        
        cloverImageView.do {
            $0.image = .cloverNone
        }
        
        dateLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "26일", style: .body2_semibold)
            $0.textColor = .black
        }
        
        dayLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "/목요일", style: .body2_semibold)
            $0.textColor = .grey02
        }
        
        replyButton.do {
             $0.backgroundColor = .lightBlue
             $0.makeCornerRound(radius: 10)
             $0.setTitleColor(.blueCustom, for: .normal)
             let attributedTitle = UIFont.pretendardString(text: "답장 확인", style: .body2_semibold)
             $0.setAttributedTitle(attributedTitle, for: .normal)
         }
        
        newImageView.do {
            $0.image = .new
        }
        
        kebabButton.do {
            $0.setImage(.kebob, for: .normal)
        }
    }
    
    func setHierarchy() {
        
        self.addSubviews(
            cloverImageView,
            dateLabel,
            dayLabel,
            replyButton,
            newImageView,
            kebabButton
        )
    }
    
    func setLayout() {
        
        cloverImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(20)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(cloverImageView)
            $0.leading.equalTo(cloverImageView.snp.trailing).offset(6)
        }
        
        dayLabel.snp.makeConstraints {
            $0.centerY.equalTo(cloverImageView)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(2)
        }
        
        replyButton.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.trailing.equalTo(kebabButton.snp.leading).offset(-4)
            $0.width.equalTo(64)
            $0.height.equalTo(28)
        }
        
        newImageView.snp.makeConstraints {
            $0.centerY.equalTo(replyButton.snp.top)
            $0.centerX.equalTo(replyButton.snp.trailing)
        }
        
        kebabButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(4)
            $0.centerY.equalTo(dateLabel)
            $0.width.equalTo(28)
            $0.height.equalTo(28)
        }
    }
    
    func bindData(diary: Diaries) {
        cloverImageView.image = UIImage(named: diary.diaryCount == 0 ? "cloverNone" : "clover\(diary.diaryCount)")
        newImageView.isHidden = diary.replyStatus != "not_read"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: diary.date) {
            let formattedDate = DateFormatter.string(from: date, format: "d")
            dateLabel.text = "\(formattedDate)일"
        } else {
            dateLabel.text = "\(diary.date.split(separator: "-").last!)일"
        }
    }
}
