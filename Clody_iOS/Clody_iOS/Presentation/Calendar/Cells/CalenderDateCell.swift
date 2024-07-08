//
//  CalenderDateCell.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/28/24.
//

import UIKit

import FSCalendar
import SnapKit
import Then

final class CalenderDateCell: FSCalendarCell {
    
    private var cloverImageView = UIImageView()
    var clendarDateLabel = UILabel()
    private let newImageView = UIImageView()
    private let backgroundSelectView = UIView()
    
    
    
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
            $0.image = .cloverNone
            $0.contentMode = .scaleAspectFit
        }
        
        clendarDateLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "20", style: .detail1_medium)
            $0.textColor = .grey05
        }
        
        newImageView.do {
            $0.image = .new
            $0.contentMode = .scaleAspectFit
        }
        
        backgroundSelectView.do {
            $0.backgroundColor = .grey02
            $0.layer.cornerRadius = 8
        }
    }
    
    func setHierarchy() {
        
        contentView.addSubviews(
            cloverImageView,
            newImageView,
            backgroundSelectView
        )
        
        backgroundSelectView.addSubview(clendarDateLabel)
    }
    
    func setLayout() {
        
        cloverImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(26)
            $0.height.equalTo(25)
        }
        
        newImageView.snp.makeConstraints {
            $0.centerY.equalTo(cloverImageView.snp.bottom)
            $0.centerX.equalTo(cloverImageView.snp.trailing)
            $0.size.equalTo(12)
        }
        
        backgroundSelectView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(6)
            $0.centerX.equalTo(cloverImageView)
            $0.horizontalEdges.equalTo(cloverImageView)
            $0.height.equalTo(16)
        }
        
        clendarDateLabel.snp.makeConstraints {
            $0.center.equalTo(backgroundSelectView)
        }
    }
}

extension CalenderDateCell {
    
    func configure(data: CalendarCellModel) {
        
        self.cloverImageView.image = UIImage(named: "clover\(data.cloverStatus)")
        let label = DateFormatter.date(from: data.date)
        self.clendarDateLabel.text = DateFormatter.string(from: label ?? Date(), format: "d")
    }
}
