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
    private let provider = MoyaProvider<MyPageRouter>()

    struct Input {
        let viewDidLoad: Signal<Void>
        let backButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let getAlarmInfo: Driver<Void>
        let selectedTimeRelay = PublishRelay<[Any]>()
        let popViewController: Driver<Void>
    }
    
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
    
    private func convertTo12HourFormat(_ time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let date = dateFormatter.date(from: time) else {
            return time
        }
        
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
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
        isDiaryAlarm: Bool,
        isReplyAlarm: Bool,
        time: String,
        completion: @escaping (PostAlarmSetResponseDTO) -> ()
    ) {
        Providers.myPageProvider.request(
            target: .postAlarmSet(
                data: PostAlarmSetRequestDTO(
                    isDiaryAlarm: isDiaryAlarm,
                    isReplyAlarm: isReplyAlarm,
                    time: time,
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
