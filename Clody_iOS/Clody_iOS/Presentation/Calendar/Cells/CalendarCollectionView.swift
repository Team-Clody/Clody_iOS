//
//  CalendarCollectionViewCell.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/4/24.
//

import UIKit

import FSCalendar
import SnapKit
import Then

final class CalendarCollectionView: UICollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - UI Componets
    
    private let cloverContinerView = UIView()
    private let cloverLabel = UILabel()
    let calendarView = FSCalendar()
    
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

        cloverContinerView.do {
            $0.layer.cornerRadius = 9
            $0.backgroundColor = .lightGreen
        }
        
        cloverLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "클로버 23개", style: .detail1_semibold)
            $0.textColor = .darkGreen
        }
        
        calendarView.do {
            $0.appearance.selectionColor = .clear
            $0.appearance.todayColor = .none
            $0.appearance.titleTodayColor = .none
            $0.appearance.titleSelectionColor = .none
            $0.appearance.borderSelectionColor = .clear
            $0.appearance.borderDefaultColor = .clear
            $0.scope = .month
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.locale = Locale(identifier: "ko_KR")
            $0.appearance.headerDateFormat = "YYYY년 M월"
            $0.headerHeight = 0
            $0.weekdayHeight = 50
        }
    }
    
    func setHierarchy() {
        
        contentView.addSubviews(
            cloverContinerView,
            calendarView
        )
        
        cloverContinerView.addSubview(cloverLabel)
    }
    
    func setLayout() {
        
        cloverContinerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(83)
            $0.height.equalTo(26)
        }
        
        cloverLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(cloverContinerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension CalendarCollectionView {
    
    func configure() {
    }
}
