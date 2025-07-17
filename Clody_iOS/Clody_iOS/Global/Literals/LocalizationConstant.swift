//
//  LocalizationConstant.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/6/25.
//

import Foundation

enum LocalizationConstant {
    
    static let languageCode = Locale.current.languageCode ?? "ko"
    private static let regionCode = Locale.current.regionCode ?? "KR"
    
    private static var isKorean: Bool {
        return languageCode == "ko"
    }
    
    enum Calendar {
        static var calendarLocale: Locale {
            return Locale(identifier: "\(languageCode)_\(regionCode)")
        }
        
        static func localizedYearMonthString(year: Int, month: Int) -> String {
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = 1 
            let calendar = Foundation.Calendar(identifier: .gregorian)
            guard let date = calendar.date(from: components) else {
                return "\(year)-\(month)"
            }

            let formatter = DateFormatter()
            formatter.locale = calendarLocale
            formatter.dateFormat = isKorean ? "yyyy년 M월" : "MMMM yyyy"
            return formatter.string(from: date)
        }
        
        static func localizedYear(_ year: Int) -> String {
            return isKorean ? "\(year)년" : "\(year)"
        }
        
        static func localizedMonth(_ month: Int) -> String {
            if isKorean {
                return "\(month)월"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = calendarLocale
                let monthSymbols = dateFormatter.monthSymbols
                let index = month - 1
                return monthSymbols?[index] ?? "\(month)"
            }
        }
        
        static var yearPickerIndex: Int {
            return isKorean ? 0 : 1
        }

        static var monthPickerIndex: Int {
            return isKorean ? 1 : 0
        }

    }
    
    enum List {
        static func localizedDayString(from day: String) -> String {
            return isKorean ? "\(day)일" : "\(day)"
        }
    }
    
    enum WritingDiary {
        static var maxLength: Int {
            return isKorean ? 50 : 100
        }
        
        static var helpMessageContainerWidth: CGFloat {
            return isKorean ? ScreenUtils.getWidth(228) : ScreenUtils.getWidth(285)
        }
        
        static var helpMessageLabelLeading: CGFloat {
            return isKorean ? ScreenUtils.getWidth(8) : ScreenUtils.getWidth(9)
        }
    }
}

