import UIKit
import RxCocoa
import RxSwift
import Then

final class NotificationViewController: UIViewController {

    // MARK: - Properties

    private let viewModel = NotificationViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - UI Components

    private let rootView = NotificationView()

    // MARK: - Life Cycles

    override func loadView() {
        super.loadView()
        
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()

        let sampleData = [
            NotificationItem(title: "일기 작성 알림 받기", detail: nil, hasSwitch: true),
            NotificationItem(title: "알림 시간", detail: "오후 9시 30분", hasSwitch: false),
            NotificationItem(title: "답장 도착 알림 받기", detail: nil, hasSwitch: true)
        ]
        viewModel.notificationItems.onNext(sampleData)
    }
}

// MARK: - Extensions

private extension NotificationViewController {

    func bindViewModel() {
        viewModel.notificationItems
            .bind(to: rootView.tableView.rx.items(cellIdentifier: "NotificationCell", cellType: NotificationCell.self)) { (row, element, cell) in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct NotificationViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            NotificationViewController()
        }
        .previewDevice("iPhone 14 Pro")
    }
}

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    // MARK: - UIViewControllerRepresentable

    func makeUIViewController(context: Context) -> ViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}
#endif
