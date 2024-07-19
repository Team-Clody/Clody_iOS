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
    private var totalSeconds = 30
    private var date: Date
    private var isNew: Bool
    private let isHomeBackButton: Bool
    
    // MARK: - UI Components
     
    private let rootView = ReplyWaitingView()
    private lazy var timeLabel = rootView.timeLabel
    private lazy var openButton = rootView.openButton
    
    // MARK: - Life Cycles
    
    init(date: Date, isNew: Bool, isHomeBackButton: Bool) {
        self.date = date
        self.isNew = isNew
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
        
        bindViewModel()
        setUI()
    }
}

// MARK: - Extensions

private extension ReplyWaitingViewController {

    func bindViewModel() {
        rootView.navigationBar.backButton.rx.tap
            .subscribe(onNext: {
                if self.isHomeBackButton {
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        let timer = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { self.totalSeconds - $0 }
            .take(until: { $0 < 0 })
        
        let input = ReplyWaitingViewModel.Input(
            viewDidLoad: Observable.just(()).asSignal(onErrorJustReturn: ()),
            timer: timer,
            openButtonTapEvent: openButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.getWritingTime
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let dateTuple = date.dateToYearMonthDay()
                
                self.viewModel.getWritingTime(year: dateTuple.0, month: dateTuple.1, date: dateTuple.2) { data in
                    let createdTime = (data.HH * 3600) + (data.MM * 60) + data.SS
                    let remainingTime = (createdTime + 30) - Date().currentTimeSeconds()
                    self.totalSeconds = remainingTime
                    if remainingTime <= 0 {
                        self.totalSeconds = 0
                    }
                }
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
        
        output.getReply
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.getReply(date: self.date)
            })
            .disposed(by: disposeBag)
    }

    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
}

private extension ReplyWaitingViewController {
    func getReply(date: Date) {
        
        let year = DateFormatter.string(from: date, format: "yyyy")
        let month = DateFormatter.string(from: date, format: "MM")
        let date = DateFormatter.string(from: date, format: "dd")
        
        
        viewModel.getReply(year: Int(year) ?? 0, month: Int(month) ?? 0, date: Int(date) ?? 0) { data in
            self.navigationController?.pushViewController(
                ReplyDetailViewController(data: data, isNew: self.isNew),
                animated: true
            )
        }
    }
}
