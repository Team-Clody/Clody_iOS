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
        let backButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let popViewController: Driver<Void>
    }

    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let popViewController = input.backButtonTapEvent
            .asDriver(onErrorJustReturn: Void())
        
        return Output(
            popViewController: popViewController
        )
    }

    func getAlarmAPI(completion: @escaping (AlarmModel) -> ()) {
        let provider = Providers.myPageProvider
        
        provider.request(target: .getAlarmSet, instance: BaseResponse<GetAlarmResponseDTO>.self) { data in
            guard let response = data.data else { return }
    
            let alarmModel = AlarmModel(isDiaryAlarm: response.isDiaryAlarm, isReplyAlarm: response.isReplyAlarm, time: response.time)
            completion(alarmModel)
        }
    }
    
    func updateNotificationTime(_ time: String) {
        
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
