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
    
    private let viewModel = ReplyViewModel()
    private let disposeBag = DisposeBag()
    private var totalSeconds = 10 - 1
    
    // MARK: - UI Components
     
    private let rootView = ReplyWaitingView()
    private lazy var timeLabel = rootView.timeLabel
    
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

private extension ReplyWaitingViewController {

    func bindViewModel() {
        let timer = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { self.totalSeconds - $0 }
            .take(until: { $0 < 0 })
        
        let input = ReplyViewModel.Input(timer: timer)
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
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
                // TODO: 타이머 종료(스트림 종료)
                self?.rootView.setReplyArrivedView()
                self?.rootView.openButton.setEnabledState(to: true)
                print("🍀")
            })
            .disposed(by: disposeBag)
    }

    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
}
