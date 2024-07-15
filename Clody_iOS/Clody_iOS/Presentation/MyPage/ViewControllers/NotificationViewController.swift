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
    private var settingNotificationTimeView: SettingNotificationTimeView?
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
        settingNotificationTimeView = SettingNotificationTimeView().then {
            $0.closeHandler = { [weak self] in
                self?.settingNotificationTimeView?.removeFromSuperview()
                self?.settingNotificationTimeView = nil
            }
            $0.doneHandler = { [weak self] newTime in
                self?.selectedTime = newTime
                self?.viewModel.updateNotificationTime(newTime)
                self?.settingNotificationTimeView?.removeFromSuperview()
                self?.settingNotificationTimeView = nil
            }
        }

        guard let settingNotificationTimeView = settingNotificationTimeView else { return }
        view.addSubview(settingNotificationTimeView)

        settingNotificationTimeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    @objc private func handleCloseButton() {
        settingNotificationTimeView?.removeFromSuperview()
        settingNotificationTimeView = nil
    }

    @objc private func handleDoneButton() {
        
    }
}

// MARK: - Extensions

private extension NotificationViewController {

    func bindViewModel() {
        let input = NotificationViewModel.Input(
            backButtonTapEvent: rootView.navigationBar.backButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        bindOutput(output)
    }

    func bindOutput(_ output: NotificationViewModel.Output) {
        output.notificationItems
            .drive(rootView.tableView.rx.items(cellIdentifier: "NotificationCell", cellType: NotificationCell.self)) { [weak self] (row, element, cell) in
                cell.configure(with: element)
                
                if element.title == "알림 시간" {
                    cell.arrowImageView.isUserInteractionEnabled = true
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.arrowImageViewTapped))
                    cell.arrowImageView.addGestureRecognizer(tapGesture)
                }
            }
            .disposed(by: disposeBag)
        
        output.popViewController
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Actions

    @objc func arrowImageViewTapped() {
        showPickerView()
    }
}
