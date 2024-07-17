//
//  Date+.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/17/24.
//

import Foundation

extension Date {
    func koreanDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "EEEE" // "EEEE" 포맷은 전체 요일 이름을 반환합니다.
        return dateFormatter.string(from: self)
    }
}
