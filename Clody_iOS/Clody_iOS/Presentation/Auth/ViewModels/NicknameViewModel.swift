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
        let nextButtonIsEnabled = BehaviorRelay<Bool>(value: false)
        let errorMessage: Driver<TextFieldInputResult>
        let signUp: Driver<Void>
        let popViewController: Driver<Void>
    }
    
    let errorStatus = PublishRelay<NetworkViewJudge>()
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let charCountDidChange = input.textFieldInputEvent
            .asDriver(onErrorJustReturn: "")
        
        let isTextFieldFocused = Signal
            .merge(
                input.textFieldDidBeginEditing.map { true },
                input.textFieldDidEndEditing
            )
            .asDriver(onErrorJustReturn: false)
        
        let errorMessage = input.textFieldInputEvent
            .map { text in
                if text.count == 0 { return TextFieldInputResult.empty }
                
                let nicknameRegEx = "^[가-힣a-zA-Z0-9]+${1,10}"
                if let _ = text.range(of: nicknameRegEx, options: .regularExpression) {
                    return TextFieldInputResult.normal
                } else {
                    return TextFieldInputResult.error
                }
            }
            .asDriver(onErrorJustReturn: TextFieldInputResult.empty)
        
        let signUp = input.nextButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        let popViewController = input.backButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            charCountDidChange: charCountDidChange,
            isTextFieldFocused: isTextFieldFocused,
            errorMessage: errorMessage,
            signUp: signUp,
            popViewController: popViewController
        )
    }
}

extension NicknameViewModel {
    
    func signUp(nickname: String, completion: @escaping (Int) -> ()) {
        let platform = UserManager.shared.platformValue
        let email = (platform == LoginPlatformType.apple.rawValue ? UserManager.shared.appleEmailValue : "")
        
        Providers.authProvider.request(
            target: .signUp(
                data: SignUpRequestDTO(
                    platform: platform,
                    email: email,
                    name: nickname
                )
            ),
            instance: BaseResponse<SignUpResponseDTO>.self
        ) { response in
            switch response.status {
            case 200..<300:
                guard let data = response.data else { return }
                UserManager.shared.updateToken(data.accessToken, data.refreshToken)
                self.errorStatus.accept(.success)
            case -1:
                self.errorStatus.accept(.network)
            default:
                self.errorStatus.accept(.unknowned)
            }
            
            completion(response.status)
        }
    }
}
