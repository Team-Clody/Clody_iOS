import UIKit

import RxCocoa
import RxGesture
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
    private let timePickerView = NotificationPickerView(title: I18N.BottomSheet.viewOtherTimes)

    // MARK: - Life Cycles

    override func loadView() {
        super.loadView()
        
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        bindViewModel()
        setDelegate()
        setupPickerView()
    }
}

// MARK: - Extensions

private extension NotificationViewController {
    
    func fetchData() {
        viewModel.getAlarmAPI() { data in
            self.alarmData = data
            self.rootView.tableView.reloadData()
        }
    }

    func bindViewModel() {
        let input = NotificationViewModel.Input(
            backButtonTapEvent: rootView.navigationBar.backButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.popViewController
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.selectedTimeRelay
            .bind(onNext: { [weak self] values in
                guard let self = self else { return }
                guard let timePeriods = values[0] as? String,
                      let hour = values[1] as? Int,
                      let minute = values[2] as? Int else {
                    return
                }
                
                let hour24: Int
                if timePeriods == "오전" {
                    hour24 = (hour == 12) ? 0 : hour
                } else {
                    hour24 = (hour == 12) ? 12 : hour + 12
                }
                let hourString = hour24 < 10 ? "0\(hour24)" : "\(hour24)"
                let minuteString = minute < 10 ? "0\(minute)" : "\(minute)"
                let convertedTime = "\(hourString):\(minuteString)"
                
                self.alarmData.time = convertedTime
                
                PermissionManager.shared.checkNotificationPermission(completion: { isAuth in
                    print(isAuth)
                    if isAuth {
                        self.viewModel.postAlarmChangeAPI(
                            isDiaryAlarm: self.alarmData.isDiaryAlarm,
                            isReplyAlarm: self.alarmData.isReplyAlarm,
                            time: convertedTime
                        ) { data in
                            guard let response = data.data else { return }
                            
                            self.alarmData = AlarmModel(
                                isDiaryAlarm: response.isDiaryAlarm,
                                isReplyAlarm: response.isReplyAlarm,
                                time: response.time
                            )
                            self.rootView.tableView.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async {
                            ClodyToast.show(toastType: .alarm)
                        }
                    }
                })
            })
            .disposed(by: disposeBag)
        
        timePickerView.dimmedView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismissPickerView(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        timePickerView.closeButton.rx.tap
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

    // MARK: - Actions

    @objc func arrowImageViewTapped() {
        presentBottomSheet()
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
            cell.addGestureRecognizer(tapGesture)
        }
    
        cell.configure(with: alarmData, indexPath: indexPath.row)
        cell.selectionStyle = .none
        
        cell.switchValueChanged = { [weak self] isOn in
            guard let self = self else { return }
            if indexPath.row == 0 {
                self.alarmData.isDiaryAlarm = isOn
            } else if indexPath.row == 2 {
                self.alarmData.isReplyAlarm = isOn
            }
            
            PermissionManager.shared.checkNotificationPermission(completion: { isAuth in
                print(isAuth)
                if isAuth {
                    self.viewModel.postAlarmChangeAPI(
                        isDiaryAlarm: self.alarmData.isDiaryAlarm,
                        isReplyAlarm: self.alarmData.isReplyAlarm,
                        time: self.alarmData.time,
                        completion: { data in
                        guard let response = data.data else { return }
                        
                        self.alarmData = AlarmModel(
                            isDiaryAlarm: response.isDiaryAlarm,
                            isReplyAlarm: response.isReplyAlarm,
                            time: response.time
                        )
                        self.rootView.tableView.reloadData()
                    })
                } else {
                    ClodyToast.show(toastType: .alarm)
                }
            })
        }
        
        return cell
    }
}
