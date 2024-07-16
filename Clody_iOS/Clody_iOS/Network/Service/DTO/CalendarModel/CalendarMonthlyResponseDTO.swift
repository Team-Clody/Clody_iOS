//
//  CalendarResponseDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct CalendarMonthlyResponseDTO: Codable {
    let totalMonthlyCount: Int
    let diaries: [MonthlyDiary]
}

struct MonthlyDiary: Codable {
    let diaryCount: Int
    let replyStatus: String
}
