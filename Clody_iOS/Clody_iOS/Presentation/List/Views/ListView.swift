//
//  ListView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class ListView: UIView {
    
    // MARK: - UI Components
    
    private let navigationBarView = UIView()
    lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: listCollectionViewLayout())
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final func setUI() {
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    
    func setStyle() {
        self.backgroundColor = .white
        navigationBarView.do {
            $0.backgroundColor = .red
        }
//        
//        listCollectionView.do {
//            
//        }
    }
    
    func setHierarchy() {
        
        self.addSubviews(navigationBarView, listCollectionView)
    }
    
    func setLayout() {
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        listCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(navigationBarView.snp.bottom)
        }
    }
    
    func listCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(66))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(66))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(60)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
            
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: ListBackgroundView.description())
            section.decorationItems = [sectionBackgroundDecoration]
            
            return section
        }
        
        layout.register(ListBackgroundView.self, forDecorationViewOfKind: ListBackgroundView.description())
        return layout
    }
}

