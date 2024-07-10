//
//  ListBackgroundView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

class ListBackgroundView: UICollectionReusableView {
    private let grayBackgroundView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setHiearchy()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .whiteCustom
        makeCornerRound(radius: 10)
    }
    
    private func setHiearchy() {
        addSubview(grayBackgroundView)
    }
    
    private func setLayout() {
        grayBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
