//
//  DateFormatter+.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/5/24.
//

import Foundation


extension DateFormatter {
    static func string(from date: Date, format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    static func date(from string: String, format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)
    }

    static func convertToDoubleDigitMonth(from monthString: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        
        guard let date = formatter.date(from: monthString) else {
            return nil
        }
        
        formatter.dateFormat = "M"
        return formatter.string(from: date)
    }
    
    static func convertToDoubleDigitDay(from dayString: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        guard let date = formatter.date(from: dayString) else {
            return nil
        }
        
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    static func convertTo12HourFormat(_ time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let date = dateFormatter.date(from: time) else {
            return time
        }

        dateFormatter.dateFormat = "a h시 mm분"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    
    static func convertTo24HourFormat(
        isAM: Bool,
        hour12: Int,
        minute: Int
    ) -> String {
        let hour24 = isAM ? (hour12 == 12 ? 0 : hour12) : (hour12 == 12 ? 12 : hour12 + 12)
                
        let components = DateComponents(hour: hour24, minute: minute)
        guard let date = Calendar.current.date(from: components) else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
