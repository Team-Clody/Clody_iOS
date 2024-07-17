import UIKit

import RxCocoa
import RxSwift
import Then

final class NotificationViewController: UIViewController {

    // MARK: - Properties

    private let viewModel = NotificationViewModel()
    private let disposeBag = DisposeBag()
    private var alarmData = AlarmModel(
        isDiaryAlarm: false,
        isReplyAlarm: false,
        time: ""
    )

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
        rootView.tableView.dataSource = self
        
        viewModel.getAlarmAPI() { data in
            self.alarmData = data
            self.rootView.tableView.reloadData()
        }
    }

    private func showPickerView() {
        settingNotificationTimeView = SettingNotificationTimeView().then {
            $0.closeHandler = { [weak self] in
                self?.settingNotificationTimeView?.removeFromSuperview()
                self?.settingNotificationTimeView = nil
            }
            $0.doneHandler = { [weak self] newTime in
                self?.alarmData.time = newTime
                self?.rootView.tableView.reloadData()
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
}

// MARK: - Extensions

private extension NotificationViewController {

    func bindViewModel() {
//        cell.switchControl.rx.isOn.onNext(element.hasSwitch)
        let input = NotificationViewModel.Input(
            backButtonTapEvent: rootView.navigationBar.backButton.rx.tap.asSignal()
        )

        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        bindOutput(output)
    }

    func bindOutput(_ output: NotificationViewModel.Output) {
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

extension NotificationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationCell else { return .init() }
        if indexPath.row == 1 {
            cell.arrowImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.arrowImageViewTapped))
            cell.arrowImageView.addGestureRecognizer(tapGesture)
        }
        cell.configure(with: alarmData, indexPath: indexPath.row)
        return cell
    }
}
