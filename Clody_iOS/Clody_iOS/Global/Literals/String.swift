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
        static let ok = "확인"
        static let bundleID = "com.Clody.Clody"
        static let appLink = "https://apps.apple.com/app/6511215518"
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
}
