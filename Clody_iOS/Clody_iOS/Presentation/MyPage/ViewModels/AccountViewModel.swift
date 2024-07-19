import RxCocoa
import RxSwift

final class AccountViewModel: ViewModelType {
    let isLogoutButtonEnabled = BehaviorRelay<Bool>(value: true)
    
    struct Input {
        let backButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let popViewController: Driver<Void>
        let userInfo: Driver<(String, String)>
    }
    
    private let userInfoSubject = PublishSubject<(String, String)>()
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        let popViewController = input.backButtonTapEvent
            .asDriver(onErrorJustReturn: Void())
        
        let userInfo = userInfoSubject
            .asDriver(onErrorJustReturn: ("", ""))
                
        return Output(
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
        Providers.authProvider.request(target: .logout, instance: BaseResponse<EmptyResponseDTO>.self) { response in
            if let data = response.data {
                UserManager.shared.clearAll()
                completion()
            }
        }
    }

    func withdraw(completion: @escaping () -> ()) {
        Providers.authProvider.request(target: .revoke, instance: BaseResponse<EmptyResponseDTO>.self) { response in
            if let data = response.data {
                UserManager.shared.clearAll()
                completion()
            }
        }
    }
}
