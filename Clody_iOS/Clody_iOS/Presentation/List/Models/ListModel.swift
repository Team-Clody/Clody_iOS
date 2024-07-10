//
//  ListModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import Foundation

struct ListModel {
    let totalMonthlyCount: Int
    let diaries: [Diaries]
}

struct Diaries {
    let diaryCount: String
    let replyStatus: String
    let date: String
    let diary: [DiaryContent]
}

struct DiaryContent {
    let content: String
}
