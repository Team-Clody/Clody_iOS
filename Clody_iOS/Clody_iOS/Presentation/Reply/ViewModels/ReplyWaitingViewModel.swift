//
//  ReplyViewModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/14/24.
//

import UIKit

import RxCocoa
import RxSwift

final class ReplyWaitingViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Signal<Void>
        let timer: Observable<Int>
        let openButtonTapEvent: Signal<Void>
    }
        
    struct Output {
        let getWritingTime: Driver<Void>
        let timeLabelDidChange: Driver<String>
        let replyArrivalEvent: Driver<Void>
        let getReply: Driver<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let getWritingTime = input.viewDidLoad
            .asDriver(onErrorJustReturn: ())
        
        let timeLabelDidChange = input.timer
            .map { totalSeconds in
                let hours = totalSeconds / 3600
                let minutes = (totalSeconds % 3600) / 60
                let seconds = totalSeconds % 60
                
                /// 타이머에 나타날 String을 만든다.
                /// 시간이 두 자릿수일 때는 그대로, 한 자릿수라면 앞에 0을 붙인다.
                let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
                let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
                let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
                return "\(hoursString):\(minutesString):\(secondsString)"
            }
            .asDriver(onErrorJustReturn: "")
        
        let replyArrivalEvent = input.timer
            .filter { totalSeconds in
                /// 남은 시간이 0일 때만 이벤트 발생하도록 필터 적용
                totalSeconds == 0
            }
            .map { _ in
                return Void()
            }
            .asDriver(onErrorJustReturn: ())
        
        let getReply = input.openButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            getWritingTime: getWritingTime,
            timeLabelDidChange: timeLabelDidChange,
            replyArrivalEvent: replyArrivalEvent,
            getReply: getReply
        )
    }
}

extension ReplyWaitingViewModel {
    
    func getReply(year: Int, month: Int, date: Int, completion: @escaping (GetReplyResponseDTO) -> ()) {
        Providers.diaryRouter.request(
            target: .getReply(year: year, month: month, date: date),
            instance: BaseResponse<GetReplyResponseDTO>.self
        ) { response in
//            switch data.status {
//            case 200..<300:
//                guard let data = response.data else { return }
//                completion(data)
//            case -1:
//                
//            default:
//                
//            }
        }
    }
    
    func getWritingTime(year: Int, month: Int, date: Int, completion: @escaping (GetWritingTimeDTO) -> ()) {
        Providers.diaryRouter.request(
            target: .getWritingTime(year: year, month: month, date: date),
            instance: BaseResponse<GetWritingTimeDTO>.self
        ) { response in
//            switch data.status {
//            case 200..<300:
                guard let data = response.data else { return }
                completion(data)
//            case -1:
//                
//            default:
//                
//            }
        }
    }
}
