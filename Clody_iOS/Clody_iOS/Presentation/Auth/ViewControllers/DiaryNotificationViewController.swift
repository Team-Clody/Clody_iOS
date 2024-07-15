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
                // TODO: 알림 시간 설정 바텀시트 띄우기
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
}
