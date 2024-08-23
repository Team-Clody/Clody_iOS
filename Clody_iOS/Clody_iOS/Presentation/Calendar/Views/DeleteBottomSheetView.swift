//
//  DeleteBottomSheetView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/14/24.
//

import UIKit

import SnapKit
import Then

final class DeleteBottomSheetView: BaseView {
    
    // MARK: - UI Components
    
    let dimmedView = UIView()
    let bottomSheetView = UIView()
    let deleteIcon = UIImageView()
    private let deleteLabel = UILabel()
    let deleteContainer = UIView()
    
    override func setStyle() {
        dimmedView.do {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
        
        bottomSheetView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.clipsToBounds = true
        }
        
        deleteIcon.do {
            $0.image = .trash
            $0.contentMode = .scaleAspectFit
        }
        
        deleteLabel.do {
            $0.textColor = .grey03
            $0.attributedText = UIFont.pretendardString(text: I18N.Calendar.delete, style: .body4_medium)
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(dimmedView, bottomSheetView)
        bottomSheetView.addSubviews(deleteContainer)
        deleteContainer.addSubviews(deleteIcon, deleteLabel)
    }
    
    override func setLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(94))
        }
        
        deleteContainer.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        deleteIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.size.equalTo(ScreenUtils.getWidth(34))
        }
        
        deleteLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(deleteIcon.snp.trailing).offset(ScreenUtils.getWidth(8))
        }
    }

    
    func animateShow() {
        self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: self.bottomSheetView.frame.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmedView.alpha = 1.0
            self.bottomSheetView.transform = .identity
        })
    }
    
    func animateHide(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmedView.alpha = 0.0
            self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: self.bottomSheetView.frame.height)
        }, completion: { _ in
            completion()
        })
    }
}
