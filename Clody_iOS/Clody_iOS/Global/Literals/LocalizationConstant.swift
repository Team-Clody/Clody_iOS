//
//  LocalizationConstant.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/6/25.
//

import Foundation

enum LocalizationConstant {
    
    private static let languageCode = Locale.current.languageCode
    private static let regionCode = Locale.current.regionCode
    
    enum Calendar {
        static var calendarLocale: Locale {
            return Locale(identifier: "\(languageCode)_\(regionCode)")
        }
    }
}

