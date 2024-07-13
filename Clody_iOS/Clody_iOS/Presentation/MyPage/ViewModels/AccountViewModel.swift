import RxCocoa
import RxSwift

final class AccountViewModel {
    let isLogoutButtonEnabled = BehaviorRelay<Bool>(value: true)
}
