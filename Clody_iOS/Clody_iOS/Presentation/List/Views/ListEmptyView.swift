//
//  ListEmptyView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 8/9/24.
//

import UIKit

import SnapKit
import Then

final class ListEmptyView: BaseView {
    
    // MARK: - UI Components
    
    private let announceLabel = UILabel()
    
    override func setStyle() {
        self.backgroundColor = .grey08
        
        announceLabel.do {
            $0.textColor = .grey06
            $0.attributedText = UIFont.pretendardString(
                text: .List.emptyList,
                style: .body3_regular,
                applyLineHeight: true
            )
            $0.numberOfLines = 0
        }
    }
    
    override func setHierarchy() {
        
        self.addSubview(announceLabel)
    }
    
    override func setLayout() {
        
        announceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(307))
        }
    }
}
