//
//  String+.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/25.
//

import Foundation

extension String {
    enum Calendar {
        static let calendarReply = String(localized: "calendar.reply", comment: "답장 확인")
        static let calendarWriting = String(localized: "calendar.writing", comment: "일기 쓰기")
        static let calendarEmpty = String(localized: "calendar.empty", comment: "작성된 감사 일기가 없어요!")
        static let calendarDraft = String(localized: "calendar.draft", comment: "임시저장된 일기가 있어요.")
        static let calendarDelete = String(localized: "calendar.delete", comment: "삭제하기")
        static let calendarOtherDay = String(localized: "calendar.otherDay", comment: "다른 날짜 보기")
        static let calendarComplete = String(localized: "calendar.complete", comment: "완료")
        static let calendarWriteMore = String(localized: "calendar.writeMore", comment: "이어쓰기")
    }
}

