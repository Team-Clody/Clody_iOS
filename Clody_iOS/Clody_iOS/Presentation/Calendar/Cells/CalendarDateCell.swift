//
//  CalendarDateCell.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/28/24.
//

import UIKit

import FSCalendar
import SnapKit
import Then

final class CalendarDateCell: FSCalendarCell {
    
    // MARK: - UI Components
    
    private var cloverImageView = UIImageView()
    var calendarDateLabel = UILabel()
    private let newImageView = UIImageView()
    let backgroundSelectView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    func setStyle() {
        cloverImageView.do {
            $0.image = .clover0
            $0.contentMode = .scaleAspectFit
        }
        
        calendarDateLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "", style: .detail1_medium)
            $0.textColor = .grey05
        }
        
        newImageView.do {
            $0.image = .new
            $0.contentMode = .scaleAspectFit
            $0.isHidden = true
        }
        
        backgroundSelectView.do {
            $0.backgroundColor = .grey02
            $0.layer.cornerRadius = ScreenUtils.getHeight(20) / 2
        }
    }
    
    func setHierarchy() {
        contentView.addSubviews(
            cloverImageView,
            newImageView,
            backgroundSelectView,
            calendarDateLabel
        )
    }
    
    func setLayout() {
        cloverImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(1))
            $0.width.equalTo(ScreenUtils.getWidth(26))
            $0.height.equalTo(ScreenUtils.getHeight(25))
        }
        
        newImageView.snp.makeConstraints {
            $0.centerY.equalTo(cloverImageView.snp.bottom)
            $0.centerX.equalTo(cloverImageView.snp.trailing)
            $0.size.equalTo(ScreenUtils.getWidth(12))
        }
        
        backgroundSelectView.snp.makeConstraints {
            $0.top.equalTo(cloverImageView.snp.bottom).offset(ScreenUtils.getHeight(6))
            $0.centerX.equalTo(cloverImageView)
            $0.leading.equalTo(cloverImageView).offset(-ScreenUtils.getWidth(1))
            $0.trailing.equalTo(cloverImageView).offset(ScreenUtils.getWidth(1))
            $0.height.equalTo(ScreenUtils.getHeight(20))
        }
        
        calendarDateLabel.snp.makeConstraints {
            $0.center.equalTo(backgroundSelectView)
        }
    }
}

extension CalendarDateCell {
    
    func configure(isToday: Bool, isSelected: Bool, isDeleted: Bool, date: String, data: MonthlyDiary) {
        // 캘린더 분기처리 로직
        cloverImageView.image = UIImage(named: "clover\(data.diaryCount)")
        backgroundSelectView.isHidden = true
        
        if data.replyStatus == "READY_NOT_READ" {
            newImageView.isHidden = false
        } else {
            newImageView.isHidden = true
        }
        
        if data.replyStatus == "READY_READ" {
            cloverImageView.image = UIImage(named: "clover\(data.diaryCount)")
        } else {
            cloverImageView.image = .clover0
        }
        
        if isDeleted {
            cloverImageView.image = .clover0
        }
        
        // 오늘 날짜 처리
        if isToday {
            if data.diaryCount == 0 {
                cloverImageView.image = .cloverToday
            } else {
                if isDeleted {
                    cloverImageView.image = .cloverTodayDone
                } else {
                    cloverImageView.image = (data.replyStatus == "READY_READ") ? UIImage(named: "clover\(data.diaryCount)") : .cloverTodayDone
                }
            }
        }
        
        // 선택된 날짜 처리
        if isSelected {
            backgroundSelectView.isHidden = false
            calendarDateLabel.attributedText = UIFont.pretendardString(text: date, style: .detail1_medium, color: .white)
        } else {
            calendarDateLabel.attributedText = UIFont.pretendardString(text: date, style: .detail1_medium, color: isToday ? .black : .grey05)
        }
    }
}
