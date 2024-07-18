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
    private let selectedTimeRelay = PublishRelay<[Any]>()

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
        
        bindSelectedTimeRelay()
    }
    
    private func bindSelectedTimeRelay() {
        selectedTimeRelay
            .bind(onNext: { [weak self] values in
                guard let self = self else { return }
                guard let timePeriods = values[0] as? String,
                      let hour = values[1] as? Int,
                      let minute = values[2] as? Int else {
                    return
                }
                
                let hour24 = (timePeriods == "오전" || hour == 12) ? hour : 12 + hour
                let hourString = hour24 < 10 ? "0\(hour24)" : "\(hour24)"
                let minuteString = minute < 10 ? "0\(minute)" : "\(minute)"
                let convertedTime = "\(hourString):\(minuteString)"
                
                self.alarmData.time = convertedTime
                let timeText = "\(timePeriods) \(hour)시 \(minute)분"
                
                self.viewModel.postAlarmChangeAPI(isDiaryAlarm: self.alarmData.isDiaryAlarm, isReplyAlarm: self.alarmData.isReplyAlarm, time: convertedTime, fcmToken: "")
            })
            .disposed(by: disposeBag)
    }

    private func showPickerView() {
        settingNotificationTimeView = SettingNotificationTimeView().then {
            $0.closeHandler = { [weak self] in
                self?.settingNotificationTimeView?.removeFromSuperview()
                self?.settingNotificationTimeView = nil
            }
            $0.doneHandler = { [weak self] newTime in
                guard let self = self else { return }
                
                let timeComponents = newTime.split(separator: " ")
                guard timeComponents.count == 3,
                      let hour = Int(timeComponents[1].dropLast(1)),
                      let minute = Int(timeComponents[2].dropLast(1)) else { return }
                
                self.selectedTimeRelay.accept([String(timeComponents[0]), hour, minute])
                
                self.settingNotificationTimeView?.removeFromSuperview()
                self.settingNotificationTimeView = nil
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
        
        cell.switchValueChanged = { [weak self] isOn in
            guard let self = self else { return }
            if indexPath.row == 0 {
                self.alarmData.isDiaryAlarm = isOn
            } else if indexPath.row == 2 {
                self.alarmData.isReplyAlarm = isOn
            }
            self.viewModel.postAlarmChangeAPI(isDiaryAlarm: self.alarmData.isDiaryAlarm, isReplyAlarm: self.alarmData.isReplyAlarm, time: self.alarmData.time, fcmToken: "")
        }

        return cell
    }
}
