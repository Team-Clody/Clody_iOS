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
    
    let navigationBar = ClodyNavigationBar(type: .normal)
    private let waitingLottie = LottieAnimationView(name: "waitingLody")
    private lazy var replyLottie = LottieAnimationView(name: "replyLody")
    private let lottieView = UIView()
    let timeLabel = UILabel()
    let introLabel = UILabel()
    let quickReplyButton = UIButton()
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
            $0.attributedText = UIFont.pretendardString(
                text: I18N.Reply.writingDiary,
                style: .body3_medium,
                lineHeightMultiple: 1.5
            )
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        quickReplyButton.do {
            $0.configuration = UIButton.Configuration.filled()
            $0.configuration?.baseForegroundColor = .blueCustom
            $0.configuration?.baseBackgroundColor = .lightBlue
            $0.configuration?.attributedTitle = AttributedString(
                UIFont.pretendardString(text: I18N.Reply.quickReplyAfterAd, style: .body4_medium)
            )
            $0.configuration?.image = .icAd
            $0.configuration?.contentInsets = .init(top: 6, leading: 12, bottom: 6, trailing: 12)
            $0.configuration?.imagePadding = 5
            $0.makeCornerRound(radius: 16)
            $0.isHidden = true
        }
        
        openButton.do {
            $0.isEnabled = false
            $0.backgroundColor = .lightYellow
        }
    }
    
    override func setHierarchy() {
        addSubviews(navigationBar, lottieView, timeLabel, introLabel, quickReplyButton, openButton)
        lottieView.addSubviews(waitingLottie)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(44))
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        lottieView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(ScreenUtils.getHeight(121))
            $0.centerX.equalToSuperview()
        }
        
        waitingLottie.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(30))
            $0.top.equalTo(lottieView.snp.bottom).offset(ScreenUtils.getHeight(28))
            $0.centerX.equalToSuperview()
        }
        
        introLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(ScreenUtils.getHeight(4))
            $0.centerX.equalToSuperview()
        }
        
        quickReplyButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(32))
            $0.top.equalTo(introLabel.snp.bottom).offset(ScreenUtils.getHeight(28))
            $0.centerX.equalToSuperview()
        }
        
        openButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(48))
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(ScreenUtils.getHeight(5))
        }
    }
}

extension ReplyWaitingView {
    
    func setReplyArrivedView() {
        timeLabel.isHidden = false
        quickReplyButton.isHidden = true
        openButton.isHidden = false
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
        
        introLabel.snp.remakeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(ScreenUtils.getHeight(4))
            $0.centerX.equalToSuperview()
        }
    }
    
    func setLoadingView() {
        timeLabel.isHidden = true
        openButton.isHidden = true
        
        introLabel.snp.remakeConstraints {
            $0.top.equalTo(lottieView.snp.bottom).offset(ScreenUtils.getHeight(28))
            $0.centerX.equalToSuperview()
        }
        introLabel.attributedText = UIFont.pretendardString(text: I18N.Reply.waitAfterAd, style: .body3_medium)
    }
}
