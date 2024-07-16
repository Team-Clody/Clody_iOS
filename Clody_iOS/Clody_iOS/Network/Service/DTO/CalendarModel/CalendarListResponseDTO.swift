//
//  CalendarRequestDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation

struct CalendarListResponseDTO: Codable {
    let totalMonthlyCount: Int
    let diaries: [ListDiary]
}

struct ListDiary: Codable {
    let diaryCount: Int
    let replyStatus: String
    let date: String
    let diary: [ListDiaryContent]
}

struct ListDiaryContent: Codable {
    let contnet: String
}