import RxCocoa
import RxSwift

final class AccountViewModel: ViewModelType {
    let isLogoutButtonEnabled = BehaviorRelay<Bool>(value: true)
    
    struct Input {
        let backButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let popViewController: Driver<Void>
    }
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        let popViewController = input.backButtonTapEvent
            .asDriver(onErrorJustReturn: Void())
        return Output(popViewController: popViewController)
    }
    
}
