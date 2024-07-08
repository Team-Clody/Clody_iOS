import RxCocoa
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(from input: Input, disposeBag: DisposeBag) -> Output
}

final class MyPageViewModel: ViewModelType {

    struct Input {
    }
    
    struct Output {
    }
    
    let items: [(text: String, detail: String?)] = [
        ("프로필 및 계정 관리", nil),
        ("알림 설정", nil),
        ("공지사항", nil),
        ("1:1 문의하기", nil),
        ("서비스 이용 약관", nil),
        ("개인정보 처리방침", nil),
        ("앱 버전", "최신 버전")
    ]
    
    func transform(
        from input: Input,
        disposeBag: DisposeBag
    ) -> Output {
        return Output()
    }
}
