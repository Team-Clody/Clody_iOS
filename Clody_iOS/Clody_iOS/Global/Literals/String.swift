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
        enum ContinueWriting {
            static let title = "기한이 지나면\n로디의 답장을 받을 수 없어요!"
            static let subtitle = "답장 마감 전에 일기를 이어쓸 수 있도록\n알려 드리기 위해서는 알림 설정이 필요해요."
            static let notificationSettingPath = "[설정 > 앱 > 클로디 알림 허용]"
            static let enableNotification = "알림 받기"
            static let skipForNow = "다음에 하기"
        }
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
