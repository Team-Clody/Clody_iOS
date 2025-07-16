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
        static let complete = "완료"
        static let ok = "확인"
        static let bundleID = "com.Clody.Clody"
        static let appLink = "https://apps.apple.com/app/6511215518"
    }
    
    enum Alert {
        static let submitDiaryTitle = "일기를 로디에게 보낼까요?"
        static let submitDiaryMessage = "보낸 일기는 수정이 어려워요."
        static let deleteDiaryTitle = "정말 일기를 삭제할까요?"
        static let deleteDiaryMessage = "아직 답장이 오지 않았거나 삭제하고 다시 작성한 일기는 답장을 받을 수 없어요."
        static let cancel = "취소"
        static let submit = "보내기"
        static let delete = "삭제할래요"
        static let retry = "다시 시도"
        static let draftTitle = "지금까지 쓴 일기를 임시저장할까요?"
        static let draftMessage = "나가기를 누르면 작성 중인 내용이 모두 사라져요."
        static let draft = "임시저장"
        static let back = "나가기"
        static let writeMoreTitle = "임시저장된 일기를 이어 쓸까요?"
        static let writeMoreMessage = "답장 기한이 지나서 답장은 받을 수 없어요."
        static let writeMore = "이어쓰기"
    }
    
    enum Toast {
        static let needToWriteAll = "빈 칸을 채워야 보낼 수 있어요."
        static let limitFive = "일기는 5개까지만 작성할 수 있어요."
        static let alarm = "설정 > 알림 > 클로디에서 알림을 켜주세요."
        static let changeComplete = "변경을 완료했어요."
        static let notificationTimeChangeComplete = "알림 시간 설정을 완료했어요."
        static let continueWritingAlarmChangeComplete = "이어쓰기 알림 설정을 완료했어요."
    }
    
    enum BottomSheet {
        static let changeTime = "발송 시간 변경"
        static let viewOtherTimes = "다른 시간 보기"
        
        enum ContinueWriting {
            static let title = "기한이 지나면\n로디의 답장을 받을 수 없어요!"
            static let subtitle = "답장 마감 전에 일기를 이어쓸 수 있도록\n알려 드리기 위해서는 알림 설정이 필요해요."
            static let notificationSettingPath = "[설정 > 앱 > 클로디 알림 허용]"
            static let enableNotification = "알림 받기"
            static let skipForNow = "다음에 하기"
        }
    }
    
    enum Auth {
        static let onboarding_1_title = "안녕하세요!\n저는 로디라고 해요"
        static let onboarding_1_sub = "여러분이 써준 감사일기를 받고,\n칭찬과 응원을 담아 답장을 쓴답니다"
        static let onboarding_2_title = "답장마다 행운의\n네잎클로버를 함께 드려요"
        static let onboarding_2_sub = "하루에 받은 감사의 수가 많을수록\n색이 진한 네잎클로버를 전달해요"
        static let onboarding_3_title = "오늘과 전날 일기만\n작성할 수 있어요"
        static let onboarding_3_sub = "그전이나 다음날의 일기는 작성할 수\n없으니, 잊지 말고 기록해 주세요"
        static let onboarding_4_title = "이제 일기를 써볼까요?\n기다리고 있을게요!"
        static let onboarding_4_sub = "두번째 일기부터는 네잎클로버를 찾는 데\n12시간이 걸리니 조금만 기다려 주세요"
        static let notificationIntro = "몇 시에 감사일기\n작성 알림을 드릴까요?"
        static let setNext = "다음에 설정할게요"
        static let start = "시작하기"
    }
    
    enum Reply {
        static let luckyReplyForYou = "님을 위한 행운의 답장"
        static let writingDiary = "로디가 열심히 답장을 쓰고 있어요!"
        static let waitAfterAd = "로디가 답장을 거의 다 써가요!\n조금만 기다려주세요"
        static let replyReceived = "로디가 쓴 행운의 답장이 도착했어요!"
        static let quickReplyAfterAd = "광고 보고 바로 답장 받기"
        static let open = "열어보기"
        static let goodLuckToYou = "님을 위한 행운 도착"
        static let getClover = "1개의 네잎클로버 획득"
    }
    
    enum Error {
        static let network = "서비스 접속이 원활하지 않아요.\n네트워크 연결을 확인해주세요."
        static let unKnown = "일시적인 오류가 발생했어요.\n잠시 후 다시 시도해주세요."
    }
    
    enum WritingDiary {
        static let save = "저장"
        static let submit = "보내기"
        static let placeHolder = "일상 속 작은 감사함을 적어보세요."
        static let helpMessage = "신조어, 비속어, 이모지 작성은 불가능해요"
        static let replyButton = "답장 확인"
        static let inputLimitError = "2~50자까지 입력할 수 있어요."
    }
}
