//
//  NotificationViewModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

import RxCocoa
import RxSwift
import Moya

final class NotificationViewModel: ViewModelType {
    private let provider = MoyaProvider<MyPageRouter>()

    struct Input {
        let viewDidLoad: Signal<Void>
        let backButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let getAlarmInfo: Driver<Void>
        let postAlarmSetting = PublishRelay<(NotificationSettingType, NotificationState)>()
        let selectedTimeRelay = PublishRelay<[Any]>()
        let popViewController: Driver<Void>
    }
    
    let toggleChanged = PublishRelay<(NotificationSettingType, Bool)>()
    let alarmStatesRelay = BehaviorRelay(value: NotificationState())
    let getAlarmInfoErrorStatus = PublishRelay<NetworkViewJudge>()
    let postAlarmSettingErrorStatus = PublishRelay<NetworkViewJudge>()

    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let getAlarmInfo = input.viewDidLoad
            .asDriver(onErrorJustReturn: ())
        
        let popViewController = input.backButtonTapEvent
            .asDriver(onErrorJustReturn: Void())
        
        return Output(
            getAlarmInfo: getAlarmInfo,
            popViewController: popViewController
        )
    }
}

extension NotificationViewModel {
    
    func getAlarmInfo(completion: @escaping (GetAlarmResponseDTO) -> ()) {
        Providers.myPageProvider.request(target: .getAlarmSet, instance: BaseResponse<GetAlarmResponseDTO>.self) { response in
            switch response.status {
            case 200..<300:
                guard let data = response.data else { return }
                self.getAlarmInfoErrorStatus.accept(.success)
                completion(data)
            case -1:
                self.getAlarmInfoErrorStatus.accept(.network)
            default:
                self.getAlarmInfoErrorStatus.accept(.unknowned)
            }
        }
    }
    
    func postAlarmSetting(
        _ notificationState: NotificationState,
        completion: @escaping (PostAlarmSetResponseDTO) -> ()
    ) {
        Providers.myPageProvider.request(
            target: .postAlarmSet(
                data: PostAlarmSetRequestDTO(
                    isDiaryAlarm: notificationState.isDiaryWritingAlarmOn,
//                    isContinueAlarm: notificationState.isContinueWritingAlarmOn,
                    isReplyAlarm: notificationState.isReplyAlarmOn,
                    time: notificationState.alarmTime,
                    fcmToken: UserManager.shared.fcmTokenValue
                )
            ),
            instance: BaseResponse<PostAlarmSetResponseDTO>.self
        ) { response in
            switch response.status {
            case 200..<300:
                guard let data = response.data else { return }
                self.postAlarmSettingErrorStatus.accept(.success)
                completion(data)
            case -1:
                self.postAlarmSettingErrorStatus.accept(.network)
            default:
                self.postAlarmSettingErrorStatus.accept(.unknowned)
            }
        }
    }
}
