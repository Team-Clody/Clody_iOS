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
    
    enum Toast {
        static let needToWriteAll = String(localized: "toast.needToWriteAll", comment: "빈 칸을 채워야 보낼 수 있어요.")
        static let limitFive = String(localized: "toast.limitFive", comment: "일기는 5개까지만 작성할 수 있어요.")
        static let alarm = String(localized: "toast.alarm", comment: "설정 > 알림 > 클로디에서 알림을 켜주세요.")
        static let changeComplete = String(localized: "toast.changeComplete", comment: "변경을 완료했어요.")
        static let notificationTimeChangeComplete = String(localized: "toast.notificationTimeChangeComplete", comment: "알림 시간 설정을 완료했어요.")
        static let continueWritingAlarmChangeComplete = String(localized: "toast.continueWritingAlarmChangeComplete", comment: "이어쓰기 알림 설정을 완료했어요.")
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
        static let submitDiaryTitle = String(localized: "alert.submitDiaryTitle", comment: "일기를 로디에게 보낼까요?")
        static let submitDiaryMessage = String(localized: "alert.submitDiaryMessage", comment: "보낸 일기는 수정이 어려워요.")
        static let deleteDiaryTitle = String(localized: "alert.deleteDiaryTitle", comment: "정말 일기를 삭제할까요?")
        static let deleteDiaryMessage = String(localized: "alert.deleteDiaryMessage", comment: "아직 답장이 오지 않았거나 삭제하고 다시 작성한 일기는 답장을 받을 수 없어요.")
        static let cancel = String(localized: "alert.cancel", comment: "취소")
        static let submit = String(localized: "alert.submit", comment: "보내기")
        static let delete = String(localized: "alert.delete", comment: "삭제할래요")
        static let retry = String(localized: "alert.retry", comment: "다시 시도")
        static let draftTitle = String(localized: "alert.draftTitle", comment: "지금까지 쓴 일기를 임시저장할까요?")
        static let draftMessage = String(localized: "alert.draftMessage", comment: "나가기를 누르면 작성 중인 내용이 모두 사라져요.")
        static let draft = String(localized: "alert.draft", comment: "임시저장")
        static let back = String(localized: "alert.back", comment: "나가기")
        static let writeMoreTitle = String(localized: "alert.writeMoreTitle", comment: "임시저장된 일기를 이어 쓸까요?")
        static let writeMoreMessage = String(localized: "alert.writeMoreMessage", comment: "답장 기한이 지나서 답장은 받을 수 없어요.")
        static let writeMore = String(localized: "alert.writeMore", comment: "이어쓰기")
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
    
    enum Onboarding {
        static let onboarding_1_title = String(localized: "onboarding.onboarding_1_title", comment: "안녕하세요! 저는 로디라고 해요")
        static let onboarding_1_sub = String(localized: "onboarding.onboarding_1_sub", comment: "여러분이 써준 감사일기를 받고, 칭찬과 응원을 담아 답장을 쓴답니다")
        static let onboarding_2_title = String(localized: "onboarding.onboarding_2_title", comment: "답장마다 행운의 네잎클로버를 함께 드려요")
        static let onboarding_2_sub = String(localized: "onboarding.onboarding_2_sub", comment: "하루에 받은 감사의 수가 많을수록 색이 진한 네잎클로버를 전달해요")
        static let onboarding_3_title = String(localized: "onboarding.onboarding_3_title", comment: "오늘과 전날 일기만 작성할 수 있어요")
        static let onboarding_3_sub = String(localized: "onboarding.onboarding_3_sub", comment: "그전이나 다음날의 일기는 작성할 수 없으니, 잊지 말고 기록해 주세요")
        static let onboarding_4_title = String(localized: "onboarding.onboarding_4_title", comment: "이제 일기를 써볼까요?\n기다리고 있을게요!")
        static let onboarding_4_sub = String(localized: "onboarding.onboarding_4_sub", comment: "두번째 일기부터는 네잎클로버를 찾는 데 12시간이 걸리니 조금만 기다려 주세요")
        static let start = String(localized: "onboarding.start", comment: "시작하기")
    }
    
    enum Error {
        static let network = String(
            localized: "error.network",
            comment: "서비스 접속이 원활하지 않아요. 네트워크 연결을 확인해주세요."
        )
        static let unKnown = String(
            localized: "error.unknown",
            comment: "일시적인 오류가 발생했어요. 잠시 후 다시 시도해주세요."
        )
    }
}
