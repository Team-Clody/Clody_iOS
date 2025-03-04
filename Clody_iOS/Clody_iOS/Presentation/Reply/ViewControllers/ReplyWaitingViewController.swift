//
//  ReplyWaitingViewController.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/14/24.
//

import UIKit

import GoogleMobileAds
import RxCocoa
import RxSwift
import Then

final class ReplyWaitingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = ReplyWaitingViewModel()
    private let disposeBag = DisposeBag()
    private var timer: Observable<Int>?
    private let totalSecondsSubject = BehaviorSubject<Int>(value: 0)
    private var date: Date
    private let isHomeBackButton: Bool
    private let secondsToWaitForFirstReply = 60
    private let secondsToWaitForNormalReply = 12 * 60 * 60
    private var rewardedAd: RewardedAd?
    private var hasWatchedAd = false {
        didSet {
            rootView.quickReplyButton.isHidden = hasWatchedAd
        }
    }
    
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
        loadRewardedAd()
        bindViewModel()
        setUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Extensions

private extension ReplyWaitingViewController {
    
    func loadRewardedAd() {
        DispatchQueue.main.async {
          Task {
              do {
                  self.rewardedAd = try await RewardedAd.load(
                    with: Config.adUnitId,
                    request: Request()
                  )
                  self.rewardedAd?.fullScreenContentDelegate = self
              } catch {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
              }
          }
        }
    }
    
    func addObserverForAppDidBecomeActive() {
        /// 앱이 백그라운드에서 돌아와 다시 Active 상태가 될 때를 관찰하는 Observer
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc
    func appDidBecomeActive() {
        Observable.just(())
            .bind(to: viewModel.appDidBecomeActive)
            .disposed(by: disposeBag)
    }

    func bindViewModel() {
        
        timer = totalSecondsSubject
            .flatMapLatest { totalSeconds in
                Observable<Int>
                    .interval(.seconds(1), scheduler: MainScheduler.instance)
                    .map { totalSeconds - $0 }
                    .take(until: { $0 < 0 })
            }
        
        guard let timer = timer else { return }
        
        let input = ReplyWaitingViewModel.Input(
            viewDidLoad: Observable.just(()).asSignal(onErrorJustReturn: ()),
            timer: timer,
            quickReplyButtonTapEvent: rootView.quickReplyButton.rx.tap.asSignal(),
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
                guard let self = self else { return }
                timeLabel.attributedText = UIFont.pretendardString(
                    text: timeString,
                    style: .head2
                )
            })
            .disposed(by: disposeBag)
        
        output.replyArrivalEvent
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                rootView.quickReplyButton.isHidden = true
                rootView.setReplyArrivedView()
                rootView.openButton.setEnabledState(to: true)
            })
            .disposed(by: disposeBag)
        
        output.showAd
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                if let ad = rewardedAd {
                    ad.present(from: self) {
                        print("🎁 광고 시청 완료!")
                        self.hasWatchedAd = true
                        self.getWritingTime(for: self.date.dateToYearMonthDay(), adWatched: true)
                    }
                } else {
                    print("❌ 광고가 아직 준비되지 않았습니다.")
                }
            })
            .disposed(by: disposeBag)
        
        output.pushViewController
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                pushViewController(date: self.date)
            })
            .disposed(by: disposeBag)
        
        output.popViewController
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                totalSecondsSubject.onNext(0)
                
                if isHomeBackButton {
                    navigationController?.popToRootViewController(animated: true)
                } else {
                    navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.errorStatus
            .bind(onNext: { [weak self] networkViewJudge in
                guard let self = self else { return }
                hideLoadingIndicator()
                
                switch networkViewJudge {
                case .network:
                    showRetryView(isNetworkError: true) { [weak self] in
                        guard let self = self else { return }
                        getWritingTime(for: date.dateToYearMonthDay())
                    }
                case .unknowned:
                    showRetryView(isNetworkError: false) { [weak self] in
                        guard let self = self else { return }
                        getWritingTime(for: date.dateToYearMonthDay())
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
    
    func getWritingTime(for date: (Int, Int, Int), adWatched: Bool = false) {
        viewModel.getWritingTime(
            year: date.0,
            month: date.1,
            date: date.2,
            adWatched: adWatched
        ) { [weak self] data in
            guard let self = self else { return }
            hideLoadingIndicator()
            
            let todayYear = Date().dateToYearMonthDay().0
            let todayMonth = Date().dateToYearMonthDay().1
            let todayDay = Date().dateToYearMonthDay().2
            
            // TODO: 광고 봤는지 서버에서 받아온 데이터로 hasWatchedAd 업데이트
            // TODO: 전날 일기 작성도 가능해져서 일기를 언제 썼는지도 구분 필요.
            // 서버에서 데이터 받아와서 if문 수정 (date.0,1,2 대신 writingYear/Month/Day로)
            if adWatched {
                totalSecondsSubject.onNext(7)
            } else if date.0 == todayYear,
                      date.1 == todayMonth,
                      date.2 == todayDay {
                /// 오늘 작성한 일기라면
                let createdTime = (data.HH * 3600) + (data.mm * 60) + data.ss
                let totalWaitingTime = createdTime + (data.isFirst ? secondsToWaitForFirstReply : secondsToWaitForNormalReply)
                let remainingTime = totalWaitingTime - Date().currentTimeSeconds()
                totalSecondsSubject.onNext((remainingTime <= 0) ? 0 : remainingTime)
            } else if date.0 == todayYear,
                      date.1 == todayMonth,
                      date.2 == todayDay - 1 {
                /// 어제 작성한 일기라면
                let calendar = Calendar.current
                let yesterdayDate = calendar.date(byAdding: .day, value: -1, to: Date())!
                let createdTime = calendar.date(bySettingHour: data.HH, minute: data.mm, second: data.ss, of: yesterdayDate)!
                let totalWaitingTime = createdTime.addingTimeInterval(Double(data.isFirst ? secondsToWaitForFirstReply : secondsToWaitForNormalReply))
                let remainingTime = Int(totalWaitingTime.timeIntervalSinceNow)
                totalSecondsSubject.onNext((remainingTime <= 0) ? 0 : remainingTime)
            } else {
                totalSecondsSubject.onNext(0)
            }
            
            if try! totalSecondsSubject.value() == 0 {
                rootView.quickReplyButton.isHidden = true
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

extension ReplyWaitingViewController: FullScreenContentDelegate {
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❗️Ad did fail to present full screen content.")
    }
    
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        loadRewardedAd()
    }
}
