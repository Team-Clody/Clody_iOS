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
    
    enum Calendar {
        static var calendarLocale: Locale {
            return Locale(identifier: "ko_KR")
        }
    }
}

