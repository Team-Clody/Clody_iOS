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
    
    let imageView = LottieAnimationView(name: "replyLody")
    let timeLabel = UILabel()
    private let introLabel = UILabel()
    let openButton = ClodyBottomButton(title: I18N.Reply.open)
    
    override func setStyle() {
        backgroundColor = .white
        
        imageView.do {
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
        addSubviews(imageView, timeLabel, introLabel, openButton)
    }
    
    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(ScreenUtils.getHeight(165))
            $0.centerX.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(ScreenUtils.getHeight(26))
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
//        imageView.image = .imgReplyArrived
        introLabel.attributedText = UIFont.pretendardString(text: I18N.Reply.replyArrived, style: .body3_medium)
    }
}
