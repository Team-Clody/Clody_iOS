//
//  Date+.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/17/24.
//

import Foundation

extension Date {
    func koreanDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "EEEE" // "EEEE" 포맷은 전체 요일 이름을 반환합니다.
        return dateFormatter.string(from: self)
    }
    
    func dateToYearMonthDay() -> (Int, Int, Int) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)

        if let year = dateComponents.year,
           let month = dateComponents.month,
           let day = dateComponents.day {
            return (year, month, day)
        } else { return (0, 0, 0) }
    }
    
    func currentTimeSeconds() -> Int {
        let today = Date()
        let midnight = Calendar.current.startOfDay(for: today)
        let totalSeconds = today.timeIntervalSince(midnight)
        return Int(totalSeconds)
    }
}
