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
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                showLoadingIndicator()
                getAlarmInfo()
            })
            .disposed(by: disposeBag)
        
        output.postAlarmSetting
            .subscribe(onNext: { [weak self] type, notificationState in
                self?.showLoadingIndicator()
                
                PermissionManager.shared.checkNotificationPermission() { isAuth in
                    self?.viewModel.postAlarmSetting(notificationState) { data in
                        self?.hideLoadingIndicator()
                        
                        ClodyToast.show(toastType: !isAuth ? .alarm : (type == .time) ? .notificationTimeChangeComplete : .changeComplete)
                        
                        let data = NotificationState(
                            isDiaryWritingAlarmOn: data.isDiaryAlarm,
                            isContinueWritingAlarmOn: data.isDraftAlarm,
                            alarmTime: data.time,
                            isReplyAlarmOn: data.isReplyAlarm
                        )
                        self?.viewModel.alarmStatesRelay.accept(data)
                    }
                }
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
                
                var state = viewModel.alarmStatesRelay.value
                state.alarmTime = convertedTime
                output.postAlarmSetting.accept((.time, state))
            })
            .disposed(by: disposeBag)
        
        output.popViewController
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
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
        
        viewModel.toggleChanged
            .subscribe(onNext: { [weak self] type, isOn in
                guard var state = self?.viewModel.alarmStatesRelay.value else { return }
                switch type {
                case .diaryWriting:
                    state.isDiaryWritingAlarmOn = isOn
                case .continueWriting:
                    state.isContinueWritingAlarmOn = isOn
                case .replyReceived:
                    state.isReplyAlarmOn = isOn
                default: break
                }
                output.postAlarmSetting.accept((type, state))
            })
            .disposed(by: disposeBag)
        
        viewModel.alarmStatesRelay
            .subscribe(onNext: { [weak self] _ in
                self?.rootView.tableView.reloadData()
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
            let notificationState = NotificationState(
                isDiaryWritingAlarmOn: data.isDiaryAlarm,
                isContinueWritingAlarmOn: data.isDraftAlarm,
                alarmTime: data.time,
                isReplyAlarmOn: data.isReplyAlarm
            )
            self.viewModel.alarmStatesRelay.accept(notificationState)
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
        
        if type.hasToggle {
            cell.configure(type: type)
            
            viewModel.alarmStatesRelay
                .map {
                    switch type {
                    case .diaryWriting: return $0.isDiaryWritingAlarmOn
                    case .continueWriting: return $0.isContinueWritingAlarmOn
                    case .replyReceived: return $0.isReplyAlarmOn
                    default: return false
                    }
                }
                .bind(to: cell.toggleSwitch.rx.isOn)
                .disposed(by: cell.disposeBag)
            
            cell.toggleSwitch.rx.isOn
                .skip(1)
                .distinctUntilChanged()
                .map { (type, $0) }
                .bind(to: viewModel.toggleChanged)
                .disposed(by: cell.disposeBag)
        } else {
            let currentSettingTime = viewModel.alarmStatesRelay.value.alarmTime
            timePickerView.setTime(currentSettingTime)
            cell.configure(type: type, time: currentSettingTime)
            
            cell.timeSettingButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    presentBottomSheet()
                })
                .disposed(by: cell.disposeBag)
        }
        
        cell.selectionStyle = .none
        return cell
    }
}
