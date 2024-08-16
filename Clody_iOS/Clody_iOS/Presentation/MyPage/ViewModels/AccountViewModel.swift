import RxCocoa
import RxSwift

final class AccountViewModel: ViewModelType {
    
    struct Input {
        let textFieldInputEvent: Signal<String>
        let textFieldDidBeginEditing: Signal<Void>
        let textFieldDidEndEditing: Signal<Bool>
        let changeNicknameButtonTapEvent: Signal<Void>
        let backButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let charCountDidChange: Driver<String>
        let isTextFieldFocused: Driver<Bool>
        let isDoneButtonEnabled = BehaviorRelay<Bool>(value: false)
        let errorMessage: Driver<TextFieldInputResult>
        let changeNickname: Driver<Void>
        let popViewController: Driver<Void>
        let userInfo: Driver<(String, String)>
    }
    
    private let userInfoSubject = PublishSubject<(String, String)>()
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
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
        
        let changeNickname = input.changeNicknameButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        let popViewController = input.backButtonTapEvent
            .asDriver(onErrorJustReturn: Void())
        
        let userInfo = userInfoSubject
            .asDriver(onErrorJustReturn: ("", ""))
                
        return Output(
            charCountDidChange: charCountDidChange,
            isTextFieldFocused: isTextFieldFocused,
            errorMessage: errorMessage, 
            changeNickname: changeNickname,
            popViewController: popViewController,
            userInfo: userInfo
        )
    }
}

extension AccountViewModel {
    
    func getUserInfoAPI(completion: @escaping (GetAccountResponseDTO) -> ()) {
        let provider = Providers.myPageProvider

        provider.request(target: .getAccount, instance: BaseResponse<GetAccountResponseDTO>.self, completion: { response in
            guard let data = response.data else { return }
            
            let accountModel = GetAccountResponseDTO(email: data.email, name: data.name, platform: data.platform)
            completion(accountModel)
        })
    }
    
    func patchNickNameChange(nickname: String, completion: @escaping (String) -> ()) {
        let provider = Providers.myPageProvider

        provider.request(target: .patchNickname(data: PatchNicknameRequestDTO(name: nickname)), instance: BaseResponse<PatchNicknameResponseDTO>.self, completion: { response in
            guard let data = response.data else { return }
            completion(data.name)
        })
    }
    
    func logout(completion: @escaping () -> ()) {
        UserManager.shared.clearAll()
        completion()
    }

    func withdraw(completion: @escaping (Int) -> ()) {
        Providers.authProvider.request(target: .revoke, instance: BaseResponse<EmptyResponseDTO>.self) { response in
            if response.status == 200 {
                UserManager.shared.clearAll()
            }
            completion(response.status)
        }
    }
}
