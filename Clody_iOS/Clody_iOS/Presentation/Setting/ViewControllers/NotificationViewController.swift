import UIKit

import RxCocoa
import RxGesture
import RxSwift
import Then

final class NotificationViewController: UIViewController {

    // MARK: - Properties

    private let viewModel = NotificationViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - UI Components

    private let rootView = NotificationView()
    private let timePickerView = NotificationPickerView(title: I18N.BottomSheet.viewOtherTimes)

    // MARK: - Life Cycles

    override func loadView() {
        super.loadView()
        
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setDelegate()
        setupPickerView()
    }
}

// MARK: - Extensions

private extension NotificationViewController {
    
    func bindViewModel() {
        let input = NotificationViewModel.Input(
            viewDidLoad: Observable.just(()).asSignal(onErrorJustReturn: ()),
            backButtonTapEvent: rootView.navigationBar.backButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.getAlarmInfo
            .drive(onNext: {
                self.showLoadingIndicator()
                self.getAlarmInfo()
            })
            .disposed(by: disposeBag)
        
        output.popViewController
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.selectedTimeRelay
            .bind(onNext: { [weak self] values in
                guard let self = self,
                      let timePeriods = values[0] as? String,
                      let hour = values[1] as? Int,
                      let minute = values[2] as? Int
                else { return }
                
                let hour24: Int
                if timePeriods == "오전" {
                    hour24 = (hour == 12) ? 0 : hour
                } else {
                    hour24 = (hour == 12) ? 12 : hour + 12
                }
                let hourString = hour24 < 10 ? "0\(hour24)" : "\(hour24)"
                let minuteString = minute < 10 ? "0\(minute)" : "\(minute)"
                let convertedTime = "\(hourString):\(minuteString)"
                
                showLoadingIndicator()
                changeAlarmSetting(time: convertedTime)
            })
            .disposed(by: disposeBag)
        
        timePickerView.dimmedView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismissPickerView(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        timePickerView.navigationBar.xButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismissPickerView(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        timePickerView.completeButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismissPickerView(animated: true) {
                    let selectedTimePeriodsIndex = self.timePickerView.pickerView.selectedRow(inComponent: 0)
                    let selectedHourIndex = self.timePickerView.pickerView.selectedRow(inComponent: 1)
                    let selectedMinuteIndex = self.timePickerView.pickerView.selectedRow(inComponent: 2)
                    
                    let selectedTimePeriods = self.timePickerView.pickerView.timePeriods[selectedTimePeriodsIndex]
                    let selectedHour = self.timePickerView.pickerView.hours[selectedHourIndex]
                    let selectedMinute = self.timePickerView.pickerView.minutes[selectedMinuteIndex]
                    
                    let selectedTime = ["\(selectedTimePeriods)", selectedHour, selectedMinute]
                    output.selectedTimeRelay.accept(selectedTime)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.getAlarmInfoErrorStatus
            .bind(onNext: { networkViewJudge in
                self.hideLoadingIndicator()
                
                switch networkViewJudge {
                case .network:
                    self.showRetryView(isNetworkError: true) {
                        self.getAlarmInfo()
                    }
                case .unknowned:
                    self.showRetryView(isNetworkError: false) {
                        self.getAlarmInfo()
                    }
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.postAlarmSettingErrorStatus
            .bind(onNext: { networkViewJudge in
                self.hideLoadingIndicator()
                
                switch networkViewJudge {
                case .network:
                    self.rootView.tableView.reloadData()
                    self.showErrorAlert(isNetworkError: true)
                case .unknowned:
                    self.rootView.tableView.reloadData()
                    self.showErrorAlert(isNetworkError: false)
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setDelegate() {
        rootView.tableView.dataSource = self
    }
    
    func presentBottomSheet() {
        timePickerView.isHidden = false
        timePickerView.dimmedView.alpha = 0.0
        timePickerView.animateShow()
    }
    
    func setupPickerView() {
        timePickerView.isHidden = true
        self.view.addSubview(timePickerView)
        timePickerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func dismissPickerView(animated: Bool, completion: (() -> Void)?) {
        timePickerView.animateHide {
            self.timePickerView.isHidden = true
            completion?()
        }
    }
}

private extension NotificationViewController {
    
    func getAlarmInfo() {
        viewModel.getAlarmInfo() { data in
            self.hideLoadingIndicator()
            
            self.alarmData = AlarmModel(
                isDiaryAlarm: data.isDiaryAlarm,
                isReplyAlarm: data.isReplyAlarm,
                time: data.time
            )
            self.rootView.tableView.reloadData()
        }
    }
    
    func changeAlarmSetting(
        isDiaryAlarm: Bool? = nil,
        isReplyAlarm: Bool? = nil,
        time: String? = nil
    ) {
        PermissionManager.shared.checkNotificationPermission() { isAuth in
            self.viewModel.postAlarmSetting(
                isDiaryAlarm: isDiaryAlarm ?? self.alarmData.isDiaryAlarm,
                isReplyAlarm: isReplyAlarm ?? self.alarmData.isReplyAlarm,
                time: time ?? self.alarmData.time
            ) { data in
                ClodyToast.show(toastType: !isAuth ? .alarm : (time != nil) ? .notificationTimeChangeComplete : .changeComplete)
                
                self.alarmData = AlarmModel(
                    isDiaryAlarm: data.isDiaryAlarm,
                    isReplyAlarm: data.isReplyAlarm,
                    time: data.time
                )
                
                self.rootView.tableView.reloadData()
            }
        }
    }
}

extension NotificationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationSettingType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as? NotificationTableViewCell else { return .init() }
        
        let type = NotificationSettingType.allCases[indexPath.row]
        switch type {
        case .diaryWriting:
            cell.configure(type: type, isOn: alarmData.isDiaryAlarm)
            cell.toggleSwitch.rx.isOn
                .skip(1)
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] isOn in
                    guard let self = self else { return }
                    showLoadingIndicator()
                    changeAlarmSetting(isDiaryAlarm: isOn)
                })
                .disposed(by: cell.disposeBag)
        case .continueWriting:
            // TODO: 서버 API 완성 후 반영
            cell.configure(type: type)
            print("📓")
        case .time:
            timePickerView.setTime(alarmData.time)
            cell.configure(type: type, time: alarmData.time)
            cell.timeSettingButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    presentBottomSheet()
                })
                .disposed(by: cell.disposeBag)
        case .replyReceived:
            cell.configure(type: type, isOn: alarmData.isReplyAlarm)
            cell.toggleSwitch.rx.isOn
                .skip(1)
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] isOn in
                    guard let self = self else { return }
                    showLoadingIndicator()
                    changeAlarmSetting(isReplyAlarm: isOn)
                })
                .disposed(by: cell.disposeBag)
        }
        cell.selectionStyle = .none
        
        return cell
    }
}
