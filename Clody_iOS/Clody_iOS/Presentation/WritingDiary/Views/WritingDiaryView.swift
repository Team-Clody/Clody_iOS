//
//  WritingDiaryView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class WritingDiaryView: BaseView {
    
    // MARK: - UI Components
    
    lazy var writingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: writingCollectionViewLayout())
    lazy var addButton = UIButton()
    let headerView = WritingDiaryHeaderView()
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    var dimView = UIView()
    
    // MARK: - Life Cycles
    
    override func setStyle() {
        self.backgroundColor = .white
        
        writingCollectionView.do {
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
        
        addButton.do {
            $0.setImage(.bigAddButton, for: .normal)
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(headerView, writingCollectionView, addButton)
    }
    
    override func setLayout() {

        headerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        writingCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(ScreenUtils.getHeight(16))
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(42))
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(ScreenUtils.getHeight(6))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(24))
        }
    }

    func writingCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(ScreenUtils.getHeight(100)))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(ScreenUtils.getHeight(100)))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = ScreenUtils.getHeight(8)
            
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: ScreenUtils.getWidth(24),
                bottom: ScreenUtils.getHeight(48) + ScreenUtils.getHeight(18) * 2,
                trailing: ScreenUtils.getWidth(24)
            )
            return section
        }
    }
}
