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

final class CalendarCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var dateCellData: CalendarModel = CalendarModel(month: "", cellData: [])
    
    // MARK: - UI Componets
    
    private let cloverContinerView = UIView()
    private let cloverLabel = UILabel()
    let calendarView = FSCalendar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setHierarchy()
        setLayout()
        calendarView.register(CalenderDateCell.self, forCellReuseIdentifier: CalenderDateCell.description())
        calendarView.delegate = self
        calendarView.dataSource = self
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
            
            $0.appearance.weekdayFont = .pretendard(.body3_medium)
            $0.appearance.weekdayTextColor = .grey06
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

extension CalendarCollectionViewCell {
    
    func configure(data: CalendarModel) {
        self.dateCellData = data
        calendarView.reloadData()
    }
}


extension CalendarCollectionViewCell: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalenderDateCell.description(), for: date, at: position) as? CalenderDateCell else { return FSCalendarCell() }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        print(dateCellData.cellData.first ?? "")
        if let dateForBind = dateCellData.cellData.first(where: { $0.date == dateString }) {
            cell.configure(data: dateForBind)
        } else {
            cell.configure(data: CalendarCellModel(date: "", cloverStatus: ""))
            print("error", dateCellData.cellData.first?.date ?? "nil", dateString)
        }
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(type(of: date))
        print(date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return .clear // 날짜 숫자를 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        return .clear // 서브타이틀 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜 숫자를 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜의 서브타이틀 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        return .clear // 기본 테두리 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜의 테두리 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return .clear // 기본 배경색 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜의 배경색 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titlePlaceholderColorFor date: Date) -> UIColor? {
        return .clear // 이전/다음 달 날짜 숨김
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0 // 이벤트 숨김
    }
}
