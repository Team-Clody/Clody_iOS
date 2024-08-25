//
//  String.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/30/24.
//

import Foundation

enum I18N {
    
    enum Common {
        static let year = "년"
        static let month = "월"
        static let enterNickname = "닉네임을 입력해주세요"
        static let enterEmail = "이메일을 입력해주세요"
        static let nicknameCondition = "특수문자, 띄어쓰기 없이 작성해주세요"
        static let nicknameError = "사용할 수 없는 닉네임이에요"
        static let emailError = "이메일 형식을 확인해주세요"
        static let charLimit = "/ 10"
        static let next = "다음"
        static let complete = "완료"
        static let ok = "확인"
        static let bundleID = "com.Clody.Clody"
        static let appLink = "https://apps.apple.com/app/6511215518"
    }
    
    enum Alert {
        static let logoutTitle = "로그아웃 하시겠어요?"
        static let logoutMessage = "기다릴게요, 다음에 다시 만나요!"
        static let withdrawTitle = "서비스를 탈퇴하시겠어요?"
        static let withdrawMessage = "작성하신 일기와 받은 답장 및 클로버가 모두 삭제되며 복구할 수 없어요."
        static let saveDiaryTitle = "일기를 저장할까요?"
        static let saveDiaryMessage = "저장한 일기는 수정이 어려워요."
        static let deleteDiaryTitle = "정말 일기를 삭제할까요?"
        static let deleteDiaryMessage = "삭제한 일기는 복원이 어려워요."
        static let cancel = "아니요"
        static let logout = "로그아웃"
        static let withdraw = "탈퇴할래요"
        static let save = "저장하기"
        static let delete = "삭제하기"
        static let retry = "다시 시도"
    }
    
    enum Toast {
        static let needToWriteAll = "모든 감사 일기 작성이 필요해요."
        static let limitFive = "일기는 5개까지만 작성할 수 있어요."
        static let alarm = "설정 > 알림 > 클로디에서 알림을 켜주세요."
        static let changeComplete = "변경을 완료했어요."
        static let notificationTimeChangeComplete = "알림 시간 설정을 완료했어요."
    }
    
    enum BottomSheet {
        static let changeTime = "발송 시간 변경"
        static let viewOtherTimes = "다른 시간 보기"
    }
    
    enum TermsURL {
        static let terms = "https://phrygian-open-50e.notion.site/4b8254c57c124f37afe3302ca7dd33c2?pvs=4"
        static let privacy = "https://phrygian-open-50e.notion.site/21cb8d6027404b2aa05741bcf67a4503?pvs=4"
        static let announcement = "https://phrygian-open-50e.notion.site/800f9d9e139740409ec1ebc6da0339e0?pvs=4"
        static let contactUs = "https://docs.google.com/forms/d/e/1FAIpQLSeCS3Z9ctFyqHZH7qkryOEQYQdhvNCMPT6QJ3J2GQw86WId4Q/viewform"
    }
    
    enum Auth {
        static let kakaoLogin = "카카오로 로그인"
        static let appleLogin = "Apple로 로그인"
        static let termsIntro = "Clody 이용을 위해\n약관에 동의해 주세요"
        static let allAgree = "전체 동의"
        static let required = "(필수)"
        static let clodyTerms = "Clody 이용약관"
        static let privacy = "개인정보 처리방침"
        static let emailIntro = "행운을 전하는 감사일기,\nClody예요"
        static let nickNameIntro = "만나서 반가워요!\n어떻게 불러드릴까요?"
        static let onboarding_1_title = "안녕하세요!\n저는 로디라고 해요"
        static let onboarding_1_sub = "여러분이 써준 감사일기를 받고,\n칭찬과 응원을 담아 답장을 쓴답니다"
        static let onboarding_2_title = "답장마다 행운의\n네잎클로버를 함께 드려요"
        static let onboarding_2_sub = "하루에 받은 감사의 수가 많을수록\n색이 진한 네잎클로버를 전달해요"
        static let onboarding_3_title = "오늘의 일기만\n작성할 수 있어요"
        static let onboarding_3_sub = "전날이나 다음날의 일기는 작성할 수\n없으니, 잊지 말고 기록해주세요"
        static let onboarding_4_title = "이제 일기를 써볼까요?\n기다리고 있을게요!"
        static let onboarding_4_sub = "두번째 일기부터는 네잎클로버를 찾는 데\n12시간이 걸리니 조금만 기다려 주세요"
        static let notificationIntro = "몇시에 감사일기\n작성 알림을 드릴까요?"
        static let setNext = "다음에 설정할게요"
        static let start = "시작하기"
    }
    
    enum Reply {
        static let luckyReplyForYou = "님을 위한 행운의 답장"
        static let writingDiary = "로디가 열심히 답장을 쓰고 있어요!"
        static let replyArrived = "로디가 쓴 행운의 답장이 도착했어요!"
        static let open = "열어보기"
        static let goodLuckToYou = "님을 위한 행운 도착"
        static let getClover = "1개의 네잎클로버 획득"
    }
    
    enum List {
        static let emptyList = "작성된 감사일기가 없어요"
    }
    
    enum Error {
        static let network = "서비스 접속이 원활하지 않아요.\n네트워크 연결을 확인해주세요."
        static let unKnown = "일시적인 오류가 발생했어요.\n잠시 후 다시 시도해주세요."
    }
    
    enum MyPage {
        static let newVersion = "최신 버전"
        static let setting = "설정"
        static let profile = "프로필 및 계정 관리"
        static let logout = "로그아웃"
        static let revoke = "회원탈퇴"
        static let delete = "계정을 삭제하시겠어요?"
        static let alarmSet = "알림 설정"
        static let nickNameEdit = "닉네임 변경"
        static let edit = "변경하기"
    }
    
    enum WritingDiary {
        static let save = "저장"
        static let placeHolder = "일상 속 작은 감사함을 적어보세요."
        static let helpMessage = "신조어, 비속어, 이모지 작성은 불가능해요"
        static let replyButton = "답장 확인"
    }
    
    enum Calendar {
        static let reply = "답장 확인"
        static let writing = "일기 쓰기"
        static let empty = "아직 감사 일기가 없어요!"
        static let delete = "삭제하기"
        static let otherDay = "다른 날짜 보기"
        static let complete = "완료"
    }
}
