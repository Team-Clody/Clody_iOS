//
//  LocalizationConstant.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/6/25.
//

import Foundation

enum LocalizationConstant {
    
    private static let languageCode = Locale.current.languageCode ?? "ko"
    private static let regionCode = Locale.current.regionCode ?? "KR"
    
    enum Calendar {
        static var calendarLocale: Locale {
            print("🎁",languageCode, regionCode)
            return Locale(identifier: "\(languageCode)_\(regionCode)")
        }
    }
}

