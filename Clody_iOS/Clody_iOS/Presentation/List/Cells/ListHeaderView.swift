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
            $0.contentMode = .scaleAspectFit
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
            $0.configuration = UIButton.Configuration.filled()
            $0.configuration?.baseBackgroundColor = .lightBlue
            $0.configuration?.baseForegroundColor = .blueCustom
            $0.configuration?.attributedTitle = AttributedString(
                UIFont.pretendardString(text: .WritingDiary.replyButton, style: .detail1_semibold)
            )
            $0.configuration?.contentInsets = .init(
                top: LocalizationConstant.List.replyButtonVerticalInset,
                leading: 10,
                bottom: LocalizationConstant.List.replyButtonVerticalInset,
                trailing: 10
            )
            $0.makeCornerRound(radius: 9)
        }
        
        newImageView.do {
            $0.image = .new
            $0.isHidden = true
            $0.contentMode = .scaleAspectFit
        }
        
        kebabButton.do {
            $0.setImage(.kebob, for: .normal)
            $0.contentMode = .scaleAspectFit
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
        }
    }
    
    func setHierarchy() {
        self.addSubviews(
            cloverImageView,
            dateLabel,
            dayLabel,
            replyButton,
            kebabButton,
            newImageView
        )
    }
    
    func setLayout() {
        cloverImageView.snp.makeConstraints {
            $0.width.equalTo(ScreenUtils.getWidth(24))
            $0.height.equalTo(ScreenUtils.getHeight(23))
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(20))
            $0.leading.equalToSuperview().inset(LocalizationConstant.List.diaryHorizontalInset)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(cloverImageView.snp.trailing).offset(ScreenUtils.getWidth(6))
            $0.centerY.equalTo(cloverImageView)
        }
        
        dayLabel.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.trailing).offset(ScreenUtils.getWidth(3))
            $0.bottom.equalTo(dateLabel)
            $0.bottom.equalToSuperview().inset(ScreenUtils.getHeight(19))
        }
        
        replyButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(28))
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(18))
            $0.trailing.equalTo(kebabButton.snp.leading).offset(LocalizationConstant.List.replyButtonTrailing)
        }
        
        newImageView.snp.makeConstraints {
            $0.centerY.equalTo(replyButton.snp.top)
            $0.centerX.equalTo(replyButton.snp.trailing)
        }
        
        kebabButton.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getHeight(28))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(4))
            $0.centerY.equalTo(replyButton)
        }
    }
    
    func bindData(diary: ListDiary) {
        if diary.isDeleted || diary.replyStatus == "INVALID_DRAFT" {
            replyButton.backgroundColor = .grey08
            replyButton.isEnabled = false
            replyButton.setTitleColor(.grey06, for: .normal)
        }
        
        if diary.replyStatus == "INVALID_DRAFT" {
            cloverImageView.image = .cloverDraftExpired
        } else if diary.replyStatus == "READY_READ" {
            cloverImageView.image = UIImage(named: diary.diaryCount == 0 ? "clover0" : "clover\(diary.diaryCount)")
        } else {
            cloverImageView.image = .clover0
        }
        
        newImageView.isHidden = diary.replyStatus != "READY_NOT_READ"
        
        let dateOfContent = DateFormatter.date(from: diary.date)
        guard let dayOfContent = dateOfContent?.dayOfWeek() else { return }
        dayLabel.text = "/\(dayOfContent)"
        if let date = DateFormatter.date(from: diary.date) {
            let formattedDate = DateFormatter.string(from: date, format: "dd")
            dateLabel.text = .List.date(date: formattedDate)
        } else {
            let day = diary.date.split(separator: "-").last.map(String.init) ?? ""
            dateLabel.text = .List.date(date: day)
        }
    }
}
