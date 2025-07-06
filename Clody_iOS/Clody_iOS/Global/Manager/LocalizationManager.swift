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

final class LanguageManager {
    static let shared = LanguageManager()
    
    private init() {
        let langCode = Locale.current.languageCode
        self.currentLanguage = (langCode == "ko") ? .korean : .english
        print(currentLanguage, "🎁")
    }

    private let currentLanguage: AppLanguage

    var isKorean: Bool {
        currentLanguage == .korean
    }
}
