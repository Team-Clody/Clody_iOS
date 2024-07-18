//
//  DiaryNotificationViewModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/16/24.
//

import UIKit

import RxCocoa
import RxSwift

final class DiaryNotificationViewModel: ViewModelType {
    
    struct Input {
        let timeSettingViewTapEvent: Signal<Void>
        let completeButtonTapEvent: Signal<Void>
        let setNextButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let showBottomSheet: Driver<Void>
        let setupNotification: Driver<Void>
        let setupNotificationNext: Driver<Void>
        let selectedTimeRelay = BehaviorRelay<[Any]>(value: ["오후", 9, 30])
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let showBottomSheet = input.timeSettingViewTapEvent
            .asDriver(onErrorJustReturn: ())
            
        let setupNotification = input.completeButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        let setupNotificationNext = input.setNextButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            showBottomSheet: showBottomSheet,
            setupNotification: setupNotification,
            setupNotificationNext: setupNotificationNext
        )
    }
}

extension DiaryNotificationViewModel {
    
    func setupNotification(time: String, completion: @escaping () -> ()) {
        Providers.myPageProvider.request(
            target: .postAlarmSet(
                data: PostAlarmSetRequestDTO(
                    isDiaryAlarm: true,
                    isReplyAlarm: true,
                    time: time,
                    fcmToken: UserManager.shared.fcmTokenValue
                )
            ),
            instance: BaseResponse<PostAlarmSetResponseDTO>.self
        ) { response in
            if let data = response.data {
                completion()
            }
        }
    }
}
