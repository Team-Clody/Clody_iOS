//
//  CalendarModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/28/24.
//

import Foundation

struct CalendarModel {
    let month: String
    let cellData: [CalendarCellModel]
}

struct CalendarCellModel {
    let date: String
    let cloverStatus: String
}

extension CalendarModel {
    static func dummy(monthString: String) -> CalendarModel {
        // DateFormatter 확장 사용
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"

        // monthString을 Date 객체로 변환
        guard let monthDate = dateFormatter.date(from: monthString) else {
            fatalError("Invalid month string format")
        }
        
        // 해당 월의 첫 번째 날 계산
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        var components = calendar.dateComponents([.year, .month], from: monthDate)
        components.day = 1
        
        guard let firstDayOfMonth = calendar.date(from: components) else {
            fatalError("Could not calculate the first day of the month")
        }
        
        // 해당 월의 마지막 날 계산
        guard let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
            fatalError("Could not calculate the range of days in the month")
        }
        
        let numberOfDays = range.count
        
        // cellData 배열 생성
        var cellData: [CalendarCellModel] = []
        
        for day in 1...numberOfDays {
            components.day = day
            guard let date = calendar.date(from: components) else {
                fatalError("Could not calculate the date for day \(day)")
            }
            
            let dateFormatterForDay = DateFormatter()
            dateFormatterForDay.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatterForDay.string(from: date)
            let cloverStatus = day % 2 == 0 ? "1" : "0" // 짝수 날은 "1", 홀수 날은 "0"
            let cellModel = CalendarCellModel(date: dateString, cloverStatus: cloverStatus)
            
            cellData.append(cellModel)
        }
        
        return CalendarModel(month: monthString, cellData: cellData)
    }
}
