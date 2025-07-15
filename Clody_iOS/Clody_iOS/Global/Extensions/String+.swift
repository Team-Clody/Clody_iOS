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
    
    enum Setting {
        static let profile = String(localized: "setting.profile", comment: "프로필 및 계정 관리")
        static let notification = String(localized: "setting.notification", comment: "알림 설정")
        static let announcement = String(localized: "setting.announcement", comment: "공지사항")
        static let contactUs = String(localized: "setting.contactUs", comment: "문의/제안하기")
        static let terms = String(localized: "setting.terms", comment: "서비스 이용 약관")
        static let privacy = String(localized: "setting.privacy", comment: "개인정보 처리방침")
        static let version = String(localized: "setting.version", comment: "앱 버전")
    }
}
