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
    lazy var saveButton = UIButton()
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
        }
        
        saveButton.do {
            $0.backgroundColor = .mainYellow
            $0.makeCornerRound(radius: 10)
            $0.setTitleColor(.grey01, for: .normal)
            let attributedTitle = UIFont.pretendardString(text: I18N.WritingDiary.save, style: .body2_semibold)
            $0.setAttributedTitle(attributedTitle, for: .normal)
        }
        
        addButton.do {
            $0.setImage(.addButton, for: .normal)
        }
    }
    
    override func setHierarchy() {
        self.addSubviews(headerView, writingCollectionView, saveButton, addButton)
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
        
        saveButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(48))
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(ScreenUtils.getHeight(5))
        }
        
        addButton.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(41))
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-ScreenUtils.getHeight(81))
            $0.trailing.equalTo(saveButton)
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
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: ScreenUtils.getHeight(24), bottom: 0, trailing: ScreenUtils.getHeight(24))
            return section
        }
    }
}
