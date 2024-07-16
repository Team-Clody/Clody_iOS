//
//  NotificationViewModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import UIKit

import RxCocoa
import RxSwift

final class NotificationViewModel: ViewModelType {
    let notificationItems = PublishSubject<[NotificationItem]>()
    private let updatedNotificationItems = BehaviorRelay<[NotificationItem]>(value: [])

    struct Input {
        let backButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let notificationItems: Driver<[NotificationItem]>
        let popViewController: Driver<Void>
    }

    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        notificationItems
            .bind(to: updatedNotificationItems)
            .disposed(by: disposeBag)
        
        let popViewController = input.backButtonTapEvent
            .asDriver(onErrorJustReturn: Void())
        
        return Output(notificationItems: updatedNotificationItems.asDriver(), popViewController: popViewController)
    }

    func updateNotificationTime(_ time: String) {
        var items = updatedNotificationItems.value
        if let index = items.firstIndex(where: { $0.title == "알림 시간" }) {
            items[index].detail = time
            updatedNotificationItems.accept(items)
        }
    }
}

struct NotificationItem {
    let title: String
    var detail: String?
    let hasSwitch: Bool
}

