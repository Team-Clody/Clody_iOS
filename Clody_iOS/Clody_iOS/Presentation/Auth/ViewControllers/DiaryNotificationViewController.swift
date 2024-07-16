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
    private let timePickerView = NotificationPickerView()
    
    // MARK: - UI Components
     
    private let rootView = DiaryNotificationView()
    
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
                    
                    let selectedTime = ["\(selectedTimePeriods)", "\(selectedHour)", "\(selectedMinute)"]
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
        
        output.showBottomSheet
            .drive(onNext: {
                self.presentBottomSheet()
            })
            .disposed(by: disposeBag)
        
        output.pushViewController
            .drive(onNext: {
                self.navigationController?.pushViewController(OnBoardingViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        output.selectedTimeRelay
            .bind(onNext: { values in
                let timeText = "\(values[0]) \(values[1])시 \(values[2])분"
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
}
