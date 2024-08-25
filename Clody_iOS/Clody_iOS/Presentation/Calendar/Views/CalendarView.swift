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
    let calendarNavigationView = ClodyNavigationBar(type: .calendar, date: "2024년 00월")
    private let dividerView = UIView()
    private let contentView = UIView()
    private let cloverBackgroundView = UIView()
    let cloverLabel = UILabel()
    let mainCalendarView = FSCalendar()
    let dateLabel = UILabel()
    let dayLabel = UILabel()
    lazy var kebabButton = UIButton()
    lazy var dailyDiaryCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    let emptyDiaryView = UIView()
    let emptyDiaryLabel = UILabel()
    lazy var calendarButton = UIButton()
    
    
    // MARK: - Life Cycles
    
    override func setStyle() {
        self.backgroundColor = .white
        
        calendarButton.do {
            $0.makeCornerRound(radius: 10)
            $0.backgroundColor = .grey02
            $0.setAttributedTitle(UIFont.pretendardString(text: "답장 확인", style: .body1_semibold), for: .normal)
            $0.setTitleColor(.white, for: .normal)
        }
        
        cloverBackgroundView.do {
            $0.layer.cornerRadius = 9
            $0.backgroundColor = .lightGreenBack
        }
        
        cloverLabel.do {
            $0.attributedText = UIFont.pretendardString(text: "클로버 23개", style: .detail1_semibold)
            $0.textColor = .darkGreen
        }
        
        dividerView.do {
            $0.backgroundColor = .grey08
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
            $0.scrollEnabled = false
            
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
        
        emptyDiaryView.do {
            $0.isHidden = true
        }
        
        emptyDiaryLabel.do {
            $0.attributedText = UIFont.pretendardString(text: I18N.Calendar.empty, style: .body3_regular)
            $0.textColor = .grey05
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
            dailyDiaryCollectionView,
            emptyDiaryView,
            dividerView
        )
        
        emptyDiaryView.addSubview(emptyDiaryLabel)
        
        cloverBackgroundView.addSubview(cloverLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        adjustScrollViewContentSize()
    }
    
    private func adjustScrollViewContentSize() {
        dailyDiaryCollectionView.collectionViewLayout.invalidateLayout()
        dailyDiaryCollectionView.layoutIfNeeded()
        
        let contentHeight = dailyDiaryCollectionView.contentSize.height + 612
        scrollView.contentSize = CGSize(
            width: scrollView.frame.width,
            height: ScreenUtils.getHeight(
                contentHeight
            )
        )
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(1400))
        }
        
        calendarNavigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(44))
        }
        
        cloverBackgroundView.snp.makeConstraints {
            $0.top.equalTo(calendarNavigationView.snp.bottom).offset(ScreenUtils.getHeight(4))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.width.equalTo(ScreenUtils.getWidth(83))
            $0.height.equalTo(ScreenUtils.getHeight(26))
        }
        
        cloverLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        mainCalendarView.snp.makeConstraints {
            $0.top.equalTo(cloverBackgroundView.snp.bottom).offset(ScreenUtils.getHeight(5))
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.height.equalTo(ScreenUtils.getHeight(399))
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(mainCalendarView.snp.bottom).offset(ScreenUtils.getHeight(20))
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(6))
        }
        
        calendarButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(ScreenUtils.getHeight(5))
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalTo(mainCalendarView)
            $0.height.equalTo(ScreenUtils.getHeight(48))
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(ScreenUtils.getHeight(20))
            $0.leading.equalTo(mainCalendarView)
        }
        
        dayLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(ScreenUtils.getWidth(7))
        }
        
        kebabButton.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.trailing.equalTo(mainCalendarView)
        }
        
        dailyDiaryCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(mainCalendarView)
            $0.top.equalTo(dayLabel.snp.bottom).offset(ScreenUtils.getHeight(14))
            $0.bottom.equalToSuperview()
        }
        
        emptyDiaryView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(mainCalendarView)
            $0.top.equalTo(dayLabel.snp.bottom).offset(ScreenUtils.getHeight(14))
            $0.bottom.equalToSuperview()
        }
        
        emptyDiaryLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(ScreenUtils.getHeight(59))
        }
    }

    
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(ScreenUtils.getHeight(66)))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(ScreenUtils.getHeight(66)))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = ScreenUtils.getHeight(8)
            
            return section
        }
    }
}
