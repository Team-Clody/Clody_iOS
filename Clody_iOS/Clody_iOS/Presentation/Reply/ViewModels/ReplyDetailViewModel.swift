//
//  ReplyDetailViewModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/14/24.
//

import UIKit

import RxCocoa
import RxSwift

final class ReplyDetailViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Signal<Void>
        let okButtonTapEvent: Signal<Void>
        let backButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let getReply: Driver<Void>
        let dismissAlert: Driver<Void>
        let popViewController: Driver<Void>
    }
    
    let errorStatus = PublishRelay<NetworkViewJudge>()
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let getReply = input.viewDidLoad
            .asDriver(onErrorJustReturn: ())
        
        let dismissAlert = input.okButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        let popViewController = input.backButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            getReply: getReply,
            dismissAlert: dismissAlert,
            popViewController: popViewController
        )
    }
}

extension ReplyDetailViewModel {
    
    func getReply(year: Int, month: Int, date: Int, completion: @escaping (GetReplyResponseDTO) -> ()) {
        Providers.diaryRouter.request(
            target: .getReply(year: year, month: month, date: date),
            instance: BaseResponse<GetReplyResponseDTO>.self
        ) { response in
            switch response.status {
            case 200..<300:
                guard let data = response.data else { return }
                self.errorStatus.accept(.success)
                completion(data)
            case -1:
                self.errorStatus.accept(.network)
            default:
                self.errorStatus.accept(.unknowned)
            }
        }
    }
}
