//
//  DateComponents+.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/17/25.
//

import Foundation

extension DateComponents {
    
    /// 현지화된 날짜 표기 (e.g) 한국어: "8월 13일", 영어: "August 13"
    func localizedMonthDay() -> String {
        guard let date = Calendar.current.date(from: self) else { return "" }
        let formatter = DateFormatter()
        formatter.locale = LocalizationConstant.languageCode == "ko" ?
        Locale(identifier: "ko_KR") : Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("MMMMd")
        
        return formatter.string(from: date)
    }
}
