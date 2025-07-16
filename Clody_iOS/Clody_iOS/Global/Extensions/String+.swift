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
        static let settings = String(localized: "setting.settings", comment: "설정")
        static let profile = String(localized: "setting.profile", comment: "프로필 및 계정 관리")
        static let notification = String(localized: "setting.notification", comment: "알림 설정")
        static let announcement = String(localized: "setting.announcement", comment: "공지사항")
        static let contactUs = String(localized: "setting.contactUs", comment: "문의/제안하기")
        static let terms = String(localized: "setting.terms", comment: "서비스 이용 약관")
        static let privacy = String(localized: "setting.privacy", comment: "개인정보 처리방침")
        static let version = String(localized: "setting.version", comment: "앱 버전")
        static let latestVersion = String(localized: "setting.latestVersion", comment: "최신 버전")
        static let logout = String(localized: "setting.logout", comment: "로그아웃")
        static let revoke = String(localized: "setting.revoke", comment: "회원탈퇴")
        static let delete = String(localized: "setting.delete", comment: "계정을 삭제하시겠어요?")
        static let nickNameEdit = String(localized: "setting.nickNameEdit", comment: "닉네임 변경")
        static let edit = String(localized: "setting.edit", comment: "변경하기")
        static let save = String(localized: "setting.save", comment: "변경하기(닉네임 저장)")
    }
    
    enum Notification {
        static let diaryWriting = String(localized: "notification.diaryWriting", comment: "일기 작성 알림 받기")
        static let continueWriting = String(localized: "notification.continueWriting", comment: "이어쓰기 알림 받기")
        static let time = String(localized: "notification.time", comment: "알림 시간")
        static let replyReceived = String(localized: "notification.replyReceived", comment: "답장 도착 알림 받기")
    }
    
    enum Alert {
        static let logoutTitle = String(localized: "alert.logoutTitle", comment: "로그아웃 하시겠어요?")
        static let logoutMessage = String(localized: "alert.logoutMessage", comment: "기다릴게요, 다음에 다시 만나요!")
        static let withdrawTitle = String(localized: "alert.withdrawTitle", comment: "서비스를 탈퇴하시겠어요?")
        static let withdrawMessage = String(localized: "alert.withdrawMessage", comment: "작성하신 일기와 받은 답장 및 클로버가 모두 삭제되며 복구할 수 없어요.")
        static let logout = String(localized: "alert.logout", comment: "로그아웃")
        static let withdraw = String(localized: "alert.withdraw", comment: "탈퇴할래요")
        static let no = String(localized: "alert.no", comment: "아니요")
    }
    
    enum Auth {
        static let kakaoLogin = "카카오로 로그인"
        static let appleLogin = String(localized: "auth.appleLogin", comment: "Apple로 로그인")
        static let termsIntro = String(localized: "auth.termsIntro", comment: "Clody 이용을 위해 약관에 동의해 주세요")
        static let allAgree = String(localized: "auth.allAgree", comment: "전체 동의")
        static let required = String(localized: "auth.required", comment: "(필수)")
        static let clodyTerms = String(localized: "auth.clodyTerms", comment: "Clody 이용약관")
        static let privacy = String(localized: "auth.privacy", comment: "개인정보 처리방침")
        static let nickNameIntro = String(localized: "auth.nickNameIntro", comment: "만나서 반가워요! 어떻게 불러드릴까요?")
        static let notificationIntro = String(localized: "auth.notificationIntro", comment: "몇 시에 감사일기 작성 알림을 드릴까요?")
        static let skipForNow = String(localized: "auth.skipForNow", comment: "다음에 설정할게요")
    }
    
    enum Common {
        static let next = String(localized: "common.next", comment: "다음")
        static let complete = String(localized: "common.complete", comment: "완료")
        static let enterNickname = String(localized: "common.enterNickname", comment: "닉네임을 입력해주세요")
        static let nicknameCondition = String(localized: "common.nicknameCondition", comment: "특수문자, 띄어쓰기 없이 작성해주세요")
        static let nicknameError = String(localized: "common.nicknameError", comment: "사용할 수 없는 닉네임이에요")
        static let charLimit = "/ 10"
    }
    
    enum BottomSheet {
        static let changeTime = String(localized: "bottomSheet.changeTime", comment: "발송 시간 변경")
        static let am = String(localized: "bottomSheet.am", comment: "오전")
        static let pm = String(localized: "bottomSheet.pm", comment: "오후")
    }
}
