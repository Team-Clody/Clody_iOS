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
    let diaryCount: Int
    let replyStatus: String
    let date: String
    let diary: [String]
}


extension ListModel {
    static func dummy() -> ListModel {
        let dummyDiaries = [
            Diaries(
                diaryCount: 0,
                replyStatus: "not_read",
                date: "2024-06-01",
                diary: [
                    "안녕하세요",
                    "안녕하세요. 반갑습니다. 김선우 입니다. 안녕하세요. 반갑습니다. 김선우 입니다. 안녕하세요. 반갑습니다. 김선우 입니다.",
                    "하이 나이스트 미추 웨얼알유 프롬"
                ]
            ),
            Diaries(
                diaryCount: 1,
                replyStatus: "read",
                date: "2024-06-02",
                diary: [
                    "오늘 날씨가 좋네요.",
                    "친구랑 커피 마셨어요."
                ]
            ),
            Diaries(
                diaryCount: 2,
                replyStatus: "read",
                date: "2024-06-03",
                diary: [
                    "열심히 공부 중입니다.",
                    "프로젝트 진행 중이에요."
                ]
            ),
            Diaries(
                diaryCount: 3,
                replyStatus: "read",
                date: "2024-06-04",
                diary: [
                    "오늘은 운동을 했어요.",
                    "건강한 하루였습니다."
                ]
            ),
            Diaries(
                diaryCount: 3,
                replyStatus: "read",
                date: "2024-06-05",
                diary: [
                    "독서를 했습니다.",
                    "흥미로운 책을 읽었어요."
                ]
            ),
            Diaries(
                diaryCount: 0,
                replyStatus: "read",
                date: "2024-06-06",
                diary: [
                    "영화를 봤어요.",
                    "재미있는 영화를 봤어요."
                ]
            )
        ]

        return ListModel(
            totalMonthlyCount: 23,
            diaries: dummyDiaries
        )
    }
}
