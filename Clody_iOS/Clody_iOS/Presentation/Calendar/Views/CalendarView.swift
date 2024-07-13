//
//  CalendarView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/28/24.
//

import UIKit

import SnapKit
import Then
import FSCalendar

final class CalendarView: BaseView {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    let calendarNavigationView = ClodyNavigationBar(type: .calendar, date: "2024년 7월")
    private let contentView = UIView()
    private let cloverBackgroundView = UIView()
    private let cloverLabel = UILabel()
    let mainCalendarView = FSCalendar()
    let dateLabel = UILabel()
    private let dayLabel = UILabel()
    private lazy var kebabButton = UIButton()
    lazy var dailyDiaryCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    lazy var calendarButton = UIButton()
    
    
    // MARK: - Life Cycles
    
    override func setStyle() {
        self.backgroundColor = .white
        
        calendarNavigationView.do {
            $0.backgroundColor = .red
        }
        
        calendarButton.do {
            $0.makeCornerRound(radius: 10)
            $0.backgroundColor = .grey02
            $0.setAttributedTitle(UIFont.pretendardString(text: "답장 확인", style: .body1_semibold), for: .normal)
            $0.setTitleColor(.white, for: .normal)
        }
        
        cloverBackgroundView.do {
            $0.layer.cornerRadius = 9
            $0.backgroundColor = .lightGreen
        }
        
        cloverLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "클로버 23개", style: .detail1_semibold)
            $0.textColor = .darkGreen
        }
        
        mainCalendarView.do {
            $0.placeholderType = .none
            $0.appearance.selectionColor = .clear
            $0.appearance.todayColor = .none
            $0.appearance.titleTodayColor = .none
            $0.appearance.titleSelectionColor = .none
            $0.appearance.borderSelectionColor = .clear
            $0.appearance.borderDefaultColor = .clear
            $0.scope = .month
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.locale = Locale(identifier: "ko_KR")
            $0.headerHeight = 0
            $0.weekdayHeight = 50
            $0.rowHeight = 71
            //            $0.scrollEnabled = false
            
            $0.appearance.weekdayFont = .pretendard(.body3_medium)
            $0.appearance.weekdayTextColor = .grey06
        }
        
        dailyDiaryCollectionView.do {
            $0.isScrollEnabled = false
            $0.backgroundColor = .white
        }
        
        dateLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "6.26", style: .body1_medium)
            $0.textColor = .grey04
        }
        
        dayLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "목요일", style: .body1_medium)
            $0.textColor = .grey02
        }
        
        kebabButton.do {
            $0.setImage(.kebob, for: .normal)
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(scrollView, calendarButton)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            calendarNavigationView,
            cloverBackgroundView,
            mainCalendarView,
            dateLabel,
            dayLabel,
            kebabButton,
            dailyDiaryCollectionView
        )
        
        cloverBackgroundView.addSubview(cloverLabel)
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
            $0.height.equalTo(999)
        }
        
        calendarNavigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        cloverBackgroundView.snp.makeConstraints {
            $0.top.equalTo(calendarNavigationView.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(83)
            $0.height.equalTo(26)
        }
        
        cloverLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        mainCalendarView.snp.makeConstraints {
            $0.top.equalTo(cloverBackgroundView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(399)
        }
        
        calendarButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(5)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalTo(mainCalendarView)
            $0.height.equalTo(48)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(mainCalendarView.snp.bottom).offset(20)
            $0.leading.equalTo(mainCalendarView)
        }
        
        dayLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(7)
        }
        
        kebabButton.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.trailing.equalTo(mainCalendarView)
        }
        
        dailyDiaryCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(mainCalendarView)
            $0.top.equalTo(dayLabel.snp.bottom).offset(14)
            $0.bottom.equalToSuperview()
        }
    }
    
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(66))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(66))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
}
