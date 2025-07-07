//
//  LocalizationManager.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/6/25.
//

import Foundation

enum AppLanguage: String {
    case korean = "ko"
    case english = "en"
}

final class LocalizationManager {
    static let shared = LocalizationManager()
    
    private init() {
        let langCode = Locale.current.languageCode
        self.currentLanguage = (langCode == "ko") ? .korean : .english
        
        let region = Locale.current.regionCode ?? "KR"
        self.currentRegion = region
        
        
        self.currentTimeZone = TimeZone.current
    }

    private let currentLanguage: AppLanguage
    private let currentRegion: String
    private let currentTimeZone: TimeZone

    var isKorean: Bool {
        currentLanguage == .korean
    }
    
    var region: String {
        currentRegion
    }
    
    var timeZone: TimeZone {
        currentTimeZone
    }
}
