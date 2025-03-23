//
//  SettingSectionHeaderView.swift
//  Clody_iOS
//
//  Created by 김나연 on 3/20/25.
//

import UIKit

import SnapKit
import Then

final class SettingSectionHeaderView: UITableViewHeaderFooterView {
    // TODO: classNameIdentifer extension에 만들기
    static var reuseIdentifier: String = "SettingSectionHeaderView"
    
    private let divider = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .white
        
        divider.do {
            $0.backgroundColor = .grey08
        }
    }

    private func setHierarchy() {
        contentView.addSubviews(divider)
    }

    private func setLayout() {
        divider.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(8))
            $0.horizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
