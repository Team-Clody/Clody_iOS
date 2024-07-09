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

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"

        guard let monthDate = dateFormatter.date(from: monthString) else {
            fatalError("Invalid month string format")
        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        var components = calendar.dateComponents([.year, .month], from: monthDate)
        components.day = 1
        
        guard let firstDayOfMonth = calendar.date(from: components) else {
            fatalError("Could not calculate the first day of the month")
        }
        
        guard let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
            fatalError("Could not calculate the range of days in the month")
        }
        
        let numberOfDays = range.count
        
        var cellData: [CalendarCellModel] = []
        
        for day in 1...numberOfDays {
            components.day = day
            guard let date = calendar.date(from: components) else {
                fatalError("Could not calculate the date for day \(day)")
            }
            
            let dateFormatterForDay = DateFormatter()
            dateFormatterForDay.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatterForDay.string(from: date)
            let cloverStatus = day % 2 == 0 ? "1" : "2"
            let cellModel = CalendarCellModel(date: dateString, cloverStatus: cloverStatus)
            
            cellData.append(cellModel)
        }
        
        return CalendarModel(month: monthString, cellData: cellData)
    }
}
