//
//  CalendarDiaryResponseDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct GetDiaryResponseDTO: Codable {
    let diaries: [DailyDiary]
    let isDeleted: Bool
}

struct DailyDiary: Codable {
    let content: String
}
