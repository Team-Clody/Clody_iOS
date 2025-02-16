//
//  ReplyWaitingViewController.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/14/24.
//

import UIKit

import RxCocoa
import RxSwift
import Then

final class ReplyWaitingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = ReplyWaitingViewModel()
    private let disposeBag = DisposeBag()
    private var totalSeconds = 0
    private var date: Date
    private let isHomeBackButton: Bool
    private let secondsToWaitForFirstReply = 60
    private let secondsToWaitForNormalReply = 12 * 60 * 60
    
    // MARK: - UI Components
     
    private let rootView = ReplyWaitingView()
    private lazy var timeLabel = rootView.timeLabel
    private lazy var openButton = rootView.openButton
    
    // MARK: - Life Cycles
    
    init(date: Date, isHomeBackButton: Bool) {
        self.date = date
        self.isHomeBackButton = isHomeBackButton
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserverForAppDidBecomeActive()
        bindViewModel()
        setUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Extensions

private extension ReplyWaitingViewController {
    
    func addObserverForAppDidBecomeActive() {
        /// 앱이 백그라운드에서 돌아와 다시 Active 상태가 될 때를 관찰하는 Observer
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc
    private func appDidBecomeActive() {
        Observable.just(())
            .bind(to: viewModel.appDidBecomeActive)
            .disposed(by: disposeBag)
    }

    func bindViewModel() {
        
        let timer = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { self.totalSeconds - $0 }
            .take(until: { $0 < 0 })
        
        let input = ReplyWaitingViewModel.Input(
            viewDidLoad: Observable.just(()).asSignal(onErrorJustReturn: ()),
            timer: timer,
            openButtonTapEvent: openButton.rx.tap.asSignal(),
            backButtonTapEvent: rootView.navigationBar.backButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.getWritingTime
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                showLoadingIndicator()
                let dateTuple = date.dateToYearMonthDay()
                getWritingTime(for: dateTuple)
            })
            .disposed(by: disposeBag)
        
        output.timeLabelDidChange
            .drive(onNext: { [weak self] timeString in
                self?.timeLabel.attributedText = UIFont.pretendardString(
                    text: timeString,
                    style: .head2
                )
            })
            .disposed(by: disposeBag)
        
        output.replyArrivalEvent
            .drive(onNext: { [weak self] in
                self?.rootView.setReplyArrivedView()
                self?.rootView.openButton.setEnabledState(to: true)
            })
            .disposed(by: disposeBag)
        
        output.pushViewController
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.pushViewController(date: self.date)
            })
            .disposed(by: disposeBag)
        
        output.popViewController
            .drive(onNext: {
                if self.isHomeBackButton {
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.errorStatus
            .bind(onNext: { networkViewJudge in
                self.hideLoadingIndicator()
                
                switch networkViewJudge {
                case .network:
                    self.showRetryView(isNetworkError: true) {
                        self.getWritingTime(for: self.date.dateToYearMonthDay())                        
                    }
                case .unknowned:
                    self.showRetryView(isNetworkError: false) {
                        self.getWritingTime(for: self.date.dateToYearMonthDay())
                    }
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
    }

    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
}

private extension ReplyWaitingViewController {
    
    func getWritingTime(for date: (Int, Int, Int)) {
        viewModel.getWritingTime(year: date.0, month: date.1, date: date.2) { [weak self] data in
            guard let self = self else { return }
            hideLoadingIndicator()
            
            let todayYear = Date().dateToYearMonthDay().0
            let todayMonth = Date().dateToYearMonthDay().1
            let todayDay = Date().dateToYearMonthDay().2
            
            if date.0 == todayYear,
               date.1 == todayMonth,
               date.2 == todayDay {
                /// 오늘 작성한 일기라면
                let createdTime = (data.HH * 3600) + (data.mm * 60) + data.ss
                let totalWaitingTime = createdTime + (data.isFirst ? secondsToWaitForFirstReply : secondsToWaitForNormalReply)
                let remainingTime = totalWaitingTime - Date().currentTimeSeconds()
                totalSeconds = (remainingTime <= 0) ? 0 : remainingTime
            } else if date.0 == todayYear,
                      date.1 == todayMonth,
                      date.2 == todayDay - 1 {
                /// 어제 작성한 일기라면
                let calendar = Calendar.current
                let yesterdayDate = calendar.date(byAdding: .day, value: -1, to: Date())!
                let createdTime = calendar.date(bySettingHour: data.HH, minute: data.mm, second: data.ss, of: yesterdayDate)!
                let totalWaitingTime = createdTime.addingTimeInterval(Double(data.isFirst ? secondsToWaitForFirstReply : secondsToWaitForNormalReply))
                let remainingTime = Int(totalWaitingTime.timeIntervalSinceNow)
                totalSeconds = (remainingTime <= 0) ? 0 : remainingTime
            } else {
                totalSeconds = 0
            }
        }
    }
    
    func pushViewController(date: Date) {
        if let year = Int(DateFormatter.string(from: date, format: "yyyy")),
           let month = Int(DateFormatter.string(from: date, format: "MM")),
           let day = Int(DateFormatter.string(from: date, format: "dd")) {
            
            self.navigationController?.pushViewController(
                ReplyDetailViewController(
                    year: year,
                    month: month,
                    day: day
                ),
                animated: true
            )
        }
    }
}
