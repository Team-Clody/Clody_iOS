import UIKit

import RxCocoa
import RxSwift

final class NotificationViewModel: ViewModelType {
    let notificationItems = PublishSubject<[NotificationItem]>()

    struct Input {}
    struct Output {}

    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        return Output()
    }
}

struct NotificationItem {
    let title: String
    let detail: String?
    let hasSwitch: Bool
}
