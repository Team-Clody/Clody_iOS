//
//  Date+.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/17/24.
//

import Foundation

extension Date {
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = LocalizationConstant.Calendar.calendarLocale
        dateFormatter.dateFormat = "EEEE" // "EEEE" 포맷은 전체 요일 이름을 반환합니다.
        return dateFormatter.string(from: self)
    }
    
    func dateToYearMonthDay() -> (year: Int, month: Int, day: Int) {
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
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    var isYesterday: Bool {
        return Calendar.current.isDate(self, equalTo: Date().addingTimeInterval(-86400), toGranularity: .day)
    }

    var isWritingAvailable: Bool {
        return isToday || isYesterday
    }
}

extension String {
    /// "HH:mm" 형식의 KST 문자열을 로컬 시간 문자열로 변환합니다.
    func convertKSTToLocalTime() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul") // KST 기준

        guard let dateInKST = formatter.date(from: self) else { return nil }

        formatter.timeZone = TimeZone.current // Local 기준
        return formatter.string(from: dateInKST)
    }

    /// "HH:mm" 형식의 Local 문자열을 KST 기준 시간 문자열로 변환합니다.
    func convertLocalTimeToKST() -> String? {
        let localFormatter = DateFormatter()
        localFormatter.dateFormat = "HH:mm"
        localFormatter.timeZone = TimeZone.current

        guard let localDate = localFormatter.date(from: self) else { return nil }

        let kstFormatter = DateFormatter()
        kstFormatter.dateFormat = "HH:mm"
        kstFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        return kstFormatter.string(from: localDate)
    }
}


extension String {
    /// "yyyy-MM-dd" 형식의 현지(Local) 날짜 문자열 → KST 기준 날짜 문자열로 변환
    func localDateStringToKST(format: String = "yyyy-MM-dd") -> String? {
        let localFormatter = DateFormatter()
        localFormatter.dateFormat = format
        localFormatter.timeZone = TimeZone.current
        
        guard let localDate = localFormatter.date(from: self) else { return nil }

        let kstFormatter = DateFormatter()
        kstFormatter.dateFormat = format
        kstFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        return kstFormatter.string(from: localDate)
    }
}
