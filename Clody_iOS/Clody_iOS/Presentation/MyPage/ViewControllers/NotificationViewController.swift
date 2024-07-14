import UIKit
import RxCocoa
import RxSwift
import Then

final class NotificationViewController: UIViewController {

    // MARK: - Properties

    private let viewModel = NotificationViewModel()
    private let disposeBag = DisposeBag()
    private var selectedTime: String = "오후 9시 30분"

    // MARK: - UI Components

    private let rootView = NotificationView()
    private var notificationBottomSheetView: NotificationBottomSheetView?
    private var dimmingView: UIView?
    let closeButton = UIButton()

    // MARK: - Life Cycles

    override func loadView() {
        super.loadView()
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        
        view.backgroundColor = .white

        let sampleData = [
            NotificationItem(title: "일기 작성 알림 받기", detail: nil, hasSwitch: true),
            NotificationItem(title: "알림 시간", detail: selectedTime, hasSwitch: false),
            NotificationItem(title: "답장 도착 알림 받기", detail: nil, hasSwitch: true)
        ]
        viewModel.notificationItems.onNext(sampleData)
    }

    private func showPickerView() {
        dimmingView = UIView().then {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.55)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseButton))
            $0.addGestureRecognizer(tapGesture)
        }

        notificationBottomSheetView = NotificationBottomSheetView().then {
            $0.titleLabel.text = "다른 시간 보기"
            $0.closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
            $0.doneButton.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        }

        guard let dimmingView = dimmingView, let notificationBottomSheetView = notificationBottomSheetView else { return }

        view.addSubview(dimmingView)
        view.addSubview(notificationBottomSheetView)

        dimmingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        notificationBottomSheetView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(360)
        }
    }

    @objc private func handleCloseButton() {
        notificationBottomSheetView?.removeFromSuperview()
        dimmingView?.removeFromSuperview()
        notificationBottomSheetView = nil
        dimmingView = nil
    }

    @objc private func handleDoneButton() {
        if let pickerView = notificationBottomSheetView?.pickerView {
            let selectedPeriodIndex = pickerView.selectedRow(inComponent: 0)
            let selectedHourIndex = pickerView.selectedRow(inComponent: 1)
            let selectedMinuteIndex = pickerView.selectedRow(inComponent: 2)
            
            let period = selectedPeriodIndex == 0 ? "오전" : "오후"
            let selectedHour = selectedHourIndex + 1
            let selectedMinute = selectedMinuteIndex * 10
            
            selectedTime = String(format: "%@ %d시 %02d분", period, selectedHour, selectedMinute)
            viewModel.updateNotificationTime(selectedTime)
        }
        handleCloseButton()
    }
}

// MARK: - Extensions

private extension NotificationViewController {

    func bindViewModel() {
        let output = viewModel.transform(from: NotificationViewModel.Input(), disposeBag: disposeBag)

        output.notificationItems
            .drive(rootView.tableView.rx.items(cellIdentifier: "NotificationCell", cellType: NotificationCell.self)) { (row, element, cell) in
                cell.configure(with: element)
                
                if element.title == "알림 시간" {
                    cell.arrowImageView.isUserInteractionEnabled = true
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.arrowImageViewTapped))
                    cell.arrowImageView.addGestureRecognizer(tapGesture)
                }
            }
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
    }

    @objc func arrowImageViewTapped() {
        showPickerView()
    }
}

// MARK: - Previews

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
