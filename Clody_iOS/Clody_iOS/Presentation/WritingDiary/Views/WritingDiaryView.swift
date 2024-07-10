//
//  WritingDiaryView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class WritingDiaryView: UIView {
    
    // MARK: - UI Components
    
    private let navigationBarView = UIView()
    lazy var writingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: writingCollectionViewLayout())
    private lazy var saveButton = UIButton()
    private lazy var addButton = UIButton()
    
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
        self.backgroundColor = .grey08
        
        navigationBarView.do {
            $0.backgroundColor = .red
        }
        
        writingCollectionView.do {
            $0.backgroundColor = .grey08
            $0.showsVerticalScrollIndicator = false
        }
        
        saveButton.do {
            $0.backgroundColor = .mainYellow
            $0.makeCornerRound(radius: 10)
            $0.setTitleColor(.grey01, for: .normal)
            let attributedTitle = UIFont.pretendardString(text: "저장", style: .body2_semibold)
            $0.setAttributedTitle(attributedTitle, for: .normal)
        }
        
        addButton.do {
            $0.setImage(.addButton, for: .normal)
        }
    }
    
    func setHierarchy() {
        
        self.addSubviews(navigationBarView, writingCollectionView, saveButton, addButton)
    }
    
    func setLayout() {
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        writingCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(saveButton)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(navigationBarView.snp.bottom)
        }
        
        saveButton.snp.makeConstraints{
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(48)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(5)
        }
        
        addButton.snp.makeConstraints {
            $0.size.equalTo(41)
            $0.bottom.equalTo(saveButton.snp.top).offset(-28)
            $0.trailing.equalTo(saveButton)
        }
    }
    
    func writingCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return layout
    }
}

