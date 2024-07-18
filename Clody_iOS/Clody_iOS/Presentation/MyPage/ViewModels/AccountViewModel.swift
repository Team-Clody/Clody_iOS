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
        let userInfo = userInfoSubject.asDriver(onErrorJustReturn: ("", ""))
                
        return Output(popViewController: popViewController, userInfo: userInfo)
    }
    
    func getUserInfoAPI(completion: @escaping (GetAccountResponseDTO) -> ()) {
        let provider = Providers.myPageProvider

        provider.request(target: .getAccount, instance: BaseResponse<GetAccountResponseDTO>.self, completion: { data in
            guard let response = data.data else { return }
            
            let accountModel = GetAccountResponseDTO(email: response.email, name: response.name, platform: response.platform)
            completion(accountModel)
        })
    }
    
    func patchNickNameChange(nickname: String) {
        let provider = Providers.myPageProvider

        provider.request(target: .patchNickname(data: PatchNicknameRequestDTO(name: nickname)), instance: BaseResponse<PatchNicknameResponseDTO>.self, completion: { data in
            print(data)
        })
    }

}

extension AccountViewModel {
    
    func logout(completion: @escaping () -> ()) {
        Providers.authProvider.request(target: .logout, instance: BaseResponse<EmptyResponseDTO>.self) { response in
            if let data = response.data {
                UserManager.shared.clearAll()
                print(data)
                completion()
            }
        }
    }

    func withdraw(completion: @escaping () -> ()) {
        Providers.authProvider.request(target: .revoke, instance: BaseResponse<EmptyResponseDTO>.self) { response in
            if let data = response.data {
                UserManager.shared.clearAll()
                print(data)
                completion()
            }
        }
    }
}
