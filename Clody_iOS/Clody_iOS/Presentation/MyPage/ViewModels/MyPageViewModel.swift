import RxCocoa
import RxSwift

final class MyPageViewModel: ViewModelType {

    struct Input {
    }
    
    struct Output {
    }
    
    enum Setting: String, CaseIterable {
        case profile = "프로필 및 계정 관리"
        case notification = "알림 설정"
        case announcement = "공지사항"
        case inquiry = "1:1 문의하기"
        case terms = "서비스 이용 약관"
        case privacy = "개인정보 처리방침"
        case version = "앱 버전"
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        return Output()
    }
}
