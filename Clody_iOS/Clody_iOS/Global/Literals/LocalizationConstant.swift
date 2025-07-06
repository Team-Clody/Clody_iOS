//
//  LocalizationConstant.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/6/25.
//

import Foundation

enum LocalizationConstant {
    
    private static let isKorean = LanguageManager.shared.isKorean
    
    enum Calendar {
        static var calendarLocale: Locale {
            return isKorean ? Locale(identifier: "ko_KR") : Locale(identifier: "en_US")
        }
    }
}
