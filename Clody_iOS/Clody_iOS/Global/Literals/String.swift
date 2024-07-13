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
        static let cancel = "취소"
        static let logout = "로그아웃"
        static let withdraw = "탈퇴할래요"
        static let save = "저장하기"
        static let delete = "삭제하기"
    }
    
    enum Auth {
        static let kakaoLogin = "카카오로 로그인"
        static let appleLogin = "Apple로 로그인"
        static let termsIntro = "Clody 이용을 위해\n약관에 동의해 주세요"
        static let allAgree = "전체 동의"
        static let required = "(필수)"
        static let clodyTerms = "Clody 이용약관"
        static let privacy = "개인정보 처리방침"
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
    }
    
    enum Reply {
        static let luckyReplyForYou = "님을 위한 행운의 답장"
    }
}
