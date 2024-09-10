//
//  DiaryNotificationController.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/12/24.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift
import Then

final class DiaryNotificationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = DiaryNotificationViewModel()
    private let disposeBag = DisposeBag()
    private var time = "21:30"
    
    // MARK: - UI Components
     
    private let rootView = DiaryNotificationView()
    private let timePickerView = NotificationPickerView(title: I18N.BottomSheet.changeTime)
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setUI()
        setupPickerView()
        requestPermission()
    }
}

// MARK: - Extensions

private extension DiaryNotificationViewController {

    func bindViewModel() {
        let timeSettingViewTapEvent: Signal<Void> = rootView.timeSettingView.rx.tapGesture()
            .when(.recognized)
            .asSignal(onErrorJustReturn: .init())
            .map { _ in }
        
        let input = DiaryNotificationViewModel.Input(
            timeSettingViewTapEvent: timeSettingViewTapEvent,
            completeButtonTapEvent: rootView.completeButton.rx.tap.asSignal(),
            setNextButtonTapEvent: rootView.setNextButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
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
        
        output.showBottomSheet
            .drive(onNext: {
                self.presentBottomSheet()
            })
            .disposed(by: disposeBag)
        
        output.setupNotification
            .drive(onNext: {
                self.showLoadingIndicator()
                self.setupNotification()
            })
            .disposed(by: disposeBag)
        
        output.setupNotificationNext
            .drive(onNext: {
                self.navigationController?.pushViewController(OnBoardingViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        output.selectedTimeRelay
            .bind(onNext: { values in
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
                self.time = "\(hourString):\(minuteString)"
                let timeText = "\(timePeriods) \(hour)시 \(minute)분"
                self.rootView.timeLabel.attributedText = UIFont.pretendardString(text: timeText, style: .body1_semibold)
            })
            .disposed(by: disposeBag)
    }

    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func presentBottomSheet() {
        timePickerView.isHidden = false
        timePickerView.dimmedView.alpha = 0.0
        timePickerView.animateShow()
    }
    
    private func setupPickerView() {
        timePickerView.isHidden = true
        self.view.addSubview(timePickerView)
        timePickerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func dismissPickerView(animated: Bool, completion: (() -> Void)?) {
        timePickerView.animateHide {
            self.timePickerView.isHidden = true
            completion?()
        }
    }
    
    private func requestPermission() {
        PermissionManager.shared.requestNotificationPermission(completion: { isPermitted in
            if isPermitted {
               // 알림 설정 API 통신 가능
            } else {
                // API 안보냄
            }
        })
    }
}

extension DiaryNotificationViewController {
    
    func setupNotification() {
        viewModel.setupNotification(time: time) { dataStatus in 
            self.hideLoadingIndicator()
            
            switch dataStatus {
            case .success:
                self.navigationController?.pushViewController(OnBoardingViewController(), animated: true)
            case .network:
                self.showErrorAlert(isNetworkError: true)
            case .unknowned:
                self.showErrorAlert(isNetworkError: false)
            }
        }
    }
}
