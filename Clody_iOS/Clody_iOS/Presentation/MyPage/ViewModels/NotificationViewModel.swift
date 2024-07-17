//
//  NotificationViewModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import UIKit

import RxCocoa
import RxSwift
import Moya

final class NotificationViewModel: ViewModelType {
    let notificationItems = BehaviorRelay<[NotificationItem]>(value: [])
    private let provider = MoyaProvider<MyPageRouter>()

    struct Input {
        let backButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let notificationItems: Driver<[NotificationItem]>
        let popViewController: Driver<Void>
    }

    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let popViewController = input.backButtonTapEvent
            .asDriver(onErrorJustReturn: Void())
        
        return Output(notificationItems: notificationItems.asDriver(), popViewController: popViewController)
    }

    func alarmGetAPI() {
        let provider = Providers.myPageProvider
        
        provider.request(target: .getAlarmSet, instance: BaseResponse<GetAlarmResponseDTO>.self, completion: { data in
            guard let response = data.data else { return }
            
            print("🐶")
            print(data.data?.fcmToken)
            print(data.data?.isDiaryAlarm)
            print(data.data?.isReplyAlarm)
            print(data.data?.time)
            
        })
    }

    func updateNotificationTime(_ time: String) {
        var items = notificationItems.value
        if let index = items.firstIndex(where: { $0.title == "알림 시간" }) {
            items[index].detail = time
            notificationItems.accept(items)
        }
    }
}

struct NotificationItem {
    let title: String
    var detail: String?
    let hasSwitch: Bool
}

