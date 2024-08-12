//
//  ListHeaderView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class ListHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    var cellDisposeBag = DisposeBag()
    
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
    
    override func prepareForReuse() {
            super.prepareForReuse()
            self.cellDisposeBag = DisposeBag()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStyle() {
        self.backgroundColor = .clear
        
        cloverImageView.do {
            $0.image = .clover0
        }
        
        dateLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "26일", style: .body2_semibold)
            $0.textColor = .black
        }
        
        dayLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "/목요일", style: .body4_medium)
            $0.textColor = .grey04
        }
        
        replyButton.do {
             $0.backgroundColor = .lightBlue
             $0.makeCornerRound(radius: 10)
             $0.setTitleColor(.blueCustom, for: .normal)
             let attributedTitle = UIFont.pretendardString(text: "답장 확인", style: .detail1_semibold)
             $0.setAttributedTitle(attributedTitle, for: .normal)
         }
        
        newImageView.do {
            $0.image = .new
            $0.isHidden = true
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
            $0.bottom.equalTo(dateLabel)
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
            $0.size.equalTo(28)
        }
    }
    
    func bindData(diary: ListDiary) {
        
        if diary.isDeleted {
            replyButton.backgroundColor = .grey08
            replyButton.isEnabled = false
            replyButton.setTitleColor(.grey06, for: .normal)
        }
        
        if diary.replyStatus == "READY_READ" {
            cloverImageView.image = UIImage(named: diary.diaryCount == 0 ? "clover0" : "clover\(diary.diaryCount)")
        } else {
            cloverImageView.image = .clover0
        }
            
        if diary.replyStatus == "READY_NOT_READ" {
            newImageView.isHidden = false
        }
        
        let dateOfContent = DateFormatter.date(from: diary.date)
        guard let dayOfContent = dateOfContent?.koreanDayOfWeek() else { return }
        dayLabel.text = "/\(dayOfContent)"
        if let date = DateFormatter.date(from: diary.date) {
            let formattedDate = DateFormatter.string(from: date, format: "dd")
            dateLabel.text = "\(formattedDate)일"
        } else {
            dateLabel.text = "\(diary.date.split(separator: "-").last!)일"
        }
    }
}
