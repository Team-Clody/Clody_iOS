//
//  LocalizationConstant.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/6/25.
//

import Foundation

enum LocalizationConstant {
    
    private static let isKorean = LanguageManager.shared.isKorean
    private static let region = LanguageManager.shared.region
    
    enum Calendar {
        static var calendarLocale: Locale {
            return Locale(identifier: "\(isKorean ? "ko" : "en")_\(region)")
        }
    }
}
