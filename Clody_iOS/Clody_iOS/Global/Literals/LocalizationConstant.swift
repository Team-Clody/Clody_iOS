//
//  LocalizationConstant.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/6/25.
//

import Foundation

enum LocalizationConstant {
    
    static let languageCode = Locale.current.languageCode == "ko" ? "ko" : "en"
    private static let regionCode = Locale.current.regionCode ?? "KR"
    static let timeZoneCode: String = TimeZone.current.identifier
    static let acceptLanguage = "\(languageCode)-\(regionCode)"
    
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
                let calendar = Foundation.Calendar.current
                let monthSymbol = calendar.monthSymbols[month - 1]
                return monthSymbol
            }
        }
        
        static var yearPickerIndex: Int {
            return isKorean ? 0 : 1
        }
        
        static var monthPickerIndex: Int {
            return isKorean ? 1 : 0
        }
        
        static var pickerViewWidth: CGFloat {
            return ScreenUtils.getWidth(isKorean ? 90 : 120)
        }
    }
    
    enum WritingDiary {
        static var maxLength: Int {
            return isKorean ? 50 : 100
        }
        
        static var helpMessageContainerWidth: CGFloat {
            return ScreenUtils.getWidth(isKorean ? 228 : 285)
        }
        
        static var helpMessageLabelLeading: CGFloat {
            return ScreenUtils.getWidth(isKorean ? 8 : 9)
        }
        
        static var cancelHelpButtonLeading: CGFloat {
            return ScreenUtils.getWidth(isKorean ? -3 : 0)
        }
        
        static func headerDate(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "\(languageCode)_\(regionCode)")

            if isKorean {
                formatter.dateFormat = "M월 d일 EEEE"
            } else {
                formatter.dateFormat = "EEEE, MMMM d"
            }

            return formatter.string(from: date)
        }
    }
    
    enum List {
        static var replyButtonVerticalInset: CGFloat {
            return ScreenUtils.getHeight(isKorean ? 5 : 6)
        }
        
        static var replyButtonTrailing: CGFloat {
            return ScreenUtils.getWidth(isKorean ? -4 : -2)
        }
        
        static var diaryHorizontalInset: CGFloat {
            return ScreenUtils.getWidth(isKorean ? 20 : 23)
        }
        
        static var textLeading: CGFloat {
            return ScreenUtils.getWidth(isKorean ? 40 : 43)
        }
    }
    
    enum Common {
        static var nicknameMaxLength: Int {
            return isKorean ? 10 : 15
        }
    }
}
