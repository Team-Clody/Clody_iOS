//
//  NicknameViewModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/15/24.
//

import UIKit

import RxCocoa
import RxSwift

final class NicknameViewModel: ViewModelType {
    
    struct Input {
        let textFieldInputEvent: Signal<String>
        let textFieldDidBeginEditing: Signal<Void>
        let textFieldDidEndEditing: Signal<Bool>
        let nextButtonTapEvent: Signal<Void>
        let backButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let charCountDidChange: Driver<String>
        let isTextFieldFocused: Driver<Bool>
        let nextButtonIsEnabled: Driver<Bool>
        let pushViewController: Driver<Void>
        let popViewController: Driver<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let charCountDidChange = input.textFieldInputEvent
            .asDriver(onErrorJustReturn: "")
        
        let isTextFieldFocused = Signal
            .merge(
                input.textFieldDidBeginEditing.map { true },
                input.textFieldDidEndEditing
            )
            .asDriver(onErrorJustReturn: false)
        
        let nextButtonIsEnabled = input.textFieldInputEvent
            .map {
                return $0.count > 0
            }
            .asDriver(onErrorJustReturn: false)
        
        let pushViewController = input.nextButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        let popViewController = input.backButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            charCountDidChange: charCountDidChange,
            isTextFieldFocused: isTextFieldFocused,
            nextButtonIsEnabled: nextButtonIsEnabled,
            pushViewController: pushViewController,
            popViewController: popViewController
        )
    }
}

extension NicknameViewModel {
    
    func signUp(signUpInfo: SignUpInfoModel, completion: @escaping (Int) -> ()) {
        Providers.authProvider.request(
            target: .signUp(
                data: SignUpRequestDTO(
                    platform: signUpInfo.platform,
                    email: signUpInfo.email,
                    name: signUpInfo.name,
                    id_token: signUpInfo.id_token
                )
            ),
            instance: BaseResponse<SignUpResponseDTO>.self
        ) { response in
            if response.status == 201 {
                guard let data = response.data else { return }
                UserManager.shared.updateToken(
                    data.accessToken,
                    data.refreshToken
                )
            }
            completion(response.status)
        }
    }
}
