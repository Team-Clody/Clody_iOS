//
//  String+.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/25.
//

import Foundation

extension String {
    enum Calendar {
        static let reply = String(localized: "calendar.reply", comment: "답장 확인")
        static let writing = String(localized: "calendar.writing", comment: "일기 쓰기")
        static let empty = String(localized: "calendar.empty", comment: "작성된 감사 일기가 없어요!")
        static let draft = String(localized: "calendar.draft", comment: "임시저장된 일기가 있어요.")
        static let delete = String(localized: "calendar.delete", comment: "삭제하기")
        static let otherDay = String(localized: "calendar.otherDay", comment: "다른 날짜 보기")
        static let complete = String(localized: "calendar.complete", comment: "완료")
        static let writeMore = String(localized: "calendar.writeMore", comment: "이어쓰기")
        static func cloverCount(_ count: Int) -> String {
            return String(format: String(localized: "calendar.cloverCount", comment: "클로버 n개"), count)
        }
    }
    
    enum WritingDiary {
        static let submit = String(localized: "writingDiary.submit", comment: "보내기")
        static let placeHolder = String(localized: "writingDiary.placeHolder", comment: "일상 속 작은 감사함을 적어보세요.")
        static let helpMessage = String(localized: "writingDiary.helpMessage", comment: "신조어, 비속어, 이모지 작성은 불가능해요")
        static let replyButton = String(localized: "writingDiary.replyButton", comment: "답장 확인")
        static let inputLimitError = String(localized: "writingDiary.inputLimitError", comment: "2~50자까지 입력할 수 있어요.")
    }
    
    enum TermsURL {
        static let terms = "https://www.notion.so/1c7e3fedb3f4802c8db1f3056c03973f?pvs=21"
        static let privacy = "https://www.notion.so/1c7e3fedb3f48024a334c8116255b378?pvs=21"
        static let announcement = "https://www.notion.so/1c7e3fedb3f48029b36cf9d76c5fb6d6?pvs=21"
        static let contactUs = "https://docs.google.com/forms/d/e/1FAIpQLSeCS3Z9ctFyqHZH7qkryOEQYQdhvNCMPT6QJ3J2GQw86WId4Q/viewform"
    }
    
    enum List {
        static let emptyList = String(localized: "list.emptyList", comment: "작성된 감사일기가 없어요!")
    }
    
    enum AppVersion {
        static let forceTitle = String(localized: "appVersion.forceTitle", comment: "필수 업데이트")
        static func forceMessage(_ version: String) -> String {
            return String(format: String(localized: "appVersion.forceMessage", comment: "버전 x.x.x으로 업데이트가 필요합니다."), version)
        }

        static let optionalTitle = String(localized: "appVersion.optionalTitle", comment: "업데이트 필요")
        static func optionalMessage(_ version: String) -> String {
            return String(format: String(localized: "appVersion.optionalMessage", comment: "새로운 버전 x.x.x 사용 가능"))
        }

        static let update = String(localized: "appVersion.update", comment: "업데이트")
        static let exit = String(localized: "appVersion.exit", comment: "앱 종료")
        static let later = String(localized: "appVersion.later", comment: "나중에")
    }
}

