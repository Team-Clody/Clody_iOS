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
        self.view.addSubview(timePickerView)
        timePickerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        timePickerView.isHidden = true
        
        timePickerView.completeButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {
                [weak self] _ in
                self?.dismissPickerView(animated: true,
                                        completion: {
                    // 로직
                    let selectedAMPMIndex = self?.timePickerView.pickerView.selectedRow(inComponent: 0) ?? 0
                    let selectedHourIndex = self?.timePickerView.pickerView.selectedRow(inComponent: 0) ?? 0
                    let selectedMinuteIndex = self?.timePickerView.pickerView.selectedRow(inComponent: 1) ?? 0
                    
                    guard let selectedAMPM = self?.timePickerView.pickerView.years[selectedAMPMIndex] else {
                        return
                    }
                    guard let selectedHour = self?.timePickerView.pickerView.years[selectedHourIndex] else {
                        return
                    }
                    guard let selectedMinute = self?.timePickerView.pickerView.months[selectedMinuteIndex] else {
                        return
                    }
                    
                    let selectedMonthYear = ["\(selectedAMPM)", "\(selectedHour)", "\(selectedMinute)"]
                    self?.viewModel.selectedTimeRelay.accept(selectedMonthYear)
                })
            })
            .disposed(by: disposeBag)
        
        timePickerView.dimmedView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismissPickerView(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func dismissPickerView(animated: Bool, completion: (() -> Void)?) {
        timePickerView.animateHide {
            self.timePickerView.isHidden = true
            completion?()
        }
    }
}
