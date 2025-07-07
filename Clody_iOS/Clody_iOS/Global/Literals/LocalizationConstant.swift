//
//  LocalizationConstant.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/6/25.
//

import Foundation

enum LocalizationConstant {
    
    private static let isKorean = LocalizationManager.shared.isKorean
    private static let region = LocalizationManager.shared.region
    
    enum Calendar {
        static var calendarLocale: Locale {
            return Locale(identifier: "\(isKorean ? "ko" : "en")_\(region)")
        }
    }
}
