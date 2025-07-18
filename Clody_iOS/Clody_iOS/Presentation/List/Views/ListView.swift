//
//  ListView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class ListView: BaseView {
    
    // MARK: - UI Components
    
    let navigationBarView = ClodyNavigationBar(type: .list, date: "2024년 00월")
    private let topBackgroundView = UIView()
    lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: listCollectionViewLayout())
    let listEmptyView = ListEmptyView()
    
    override func setStyle() {
        self.backgroundColor = .grey08
        
        listCollectionView.do {
            $0.backgroundColor = .grey08
            $0.showsVerticalScrollIndicator = false
            $0.isHidden = true
        }
        
        topBackgroundView.do {
            $0.backgroundColor = .white
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(navigationBarView, listCollectionView, topBackgroundView, listEmptyView)
    }
    
    override func setLayout() {
        topBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(navigationBarView.snp.top)
        }
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(44))
        }
        
        listCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.bottom.equalToSuperview()
            $0.top.equalTo(navigationBarView.snp.bottom).offset(ScreenUtils.getHeight(18))
        }
        
        listEmptyView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(navigationBarView.snp.bottom)
        }
    }
    
    func listCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(ScreenUtils.getHeight(42))
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(ScreenUtils.getHeight(42))
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(ScreenUtils.getHeight(60))
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            section.interGroupSpacing = ScreenUtils.getHeight(13)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
            
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: ListBackgroundView.description())
            section.decorationItems = [sectionBackgroundDecoration]
            
            return section
        }
        
        setInterSectionSpacing(layout)
        layout.register(ListBackgroundView.self, forDecorationViewOfKind: ListBackgroundView.description())
        return layout
    }
    
    private func setInterSectionSpacing(_ layout: UICollectionViewCompositionalLayout) {
          let config = UICollectionViewCompositionalLayoutConfiguration()
          config.interSectionSpacing = ScreenUtils.getHeight(13)
          layout.configuration = config
    }
}
