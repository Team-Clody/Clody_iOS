//
//  ReplyWaitingView.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/14/24.
//

import UIKit

import SnapKit
import Then
import Lottie

final class ReplyWaitingView: BaseView {
    
    private lazy var navigationBar = ClodyNavigationBar(type: .normal)
    private let waitingLottie = LottieAnimationView(name: "waitingLody")
    private lazy var replyLottie = LottieAnimationView(name: "replyLody")
    private let lottieView = UIView()
    let timeLabel = UILabel()
    private let introLabel = UILabel()
    let openButton = ClodyBottomButton(title: I18N.Reply.open)
    
    override func setStyle() {
        backgroundColor = .white
        
        waitingLottie.do {
            $0.play()
            $0.loopMode = .loop
        }
        
        timeLabel.do {
            $0.textColor = .grey01
        }
        
        introLabel.do {
            $0.textColor = .grey04
            $0.attributedText = UIFont.pretendardString(text: I18N.Reply.writingDiary, style: .body3_medium)
        }
        
        openButton.do {
            $0.isEnabled = false
            $0.backgroundColor = .lightYellow
        }
    }
    
    override func setHierarchy() {
        addSubviews(lottieView, timeLabel, introLabel, openButton)
        lottieView.addSubviews(waitingLottie)
    }
    
    override func setLayout() {
        lottieView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(ScreenUtils.getHeight(165))
            $0.centerX.equalToSuperview()
        }
        
        waitingLottie.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(lottieView.snp.bottom).offset(ScreenUtils.getHeight(26))
            $0.centerX.equalToSuperview()
        }
        
        introLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(ScreenUtils.getHeight(6))
            $0.centerX.equalToSuperview()
        }
        
        openButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(5)
        }
    }
}

extension ReplyWaitingView {
    
    func setReplyArrivedView() {
        introLabel.attributedText = UIFont.pretendardString(text: I18N.Reply.replyArrived, style: .body3_medium)
        waitingLottie.removeFromSuperview()
        lottieView.addSubview(replyLottie)
        
        replyLottie.do {
            $0.play()
            $0.loopMode = .loop
        }
        
        replyLottie.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setNavigationBar() {
        self.addSubviews(navigationBar)
        
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        lottieView.snp.remakeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(ScreenUtils.getHeight(121))
            $0.centerX.equalToSuperview()
        }
    }
}
