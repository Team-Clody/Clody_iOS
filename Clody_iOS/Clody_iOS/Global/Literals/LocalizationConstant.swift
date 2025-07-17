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

