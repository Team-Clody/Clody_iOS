//
//  CalendarView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/28/24.
//

import UIKit

import SnapKit
import Then

class CalendarView: UIView {
    
    // MARK: - UI Components
    
    private let calendarNavigationView = UIView()
    lazy var calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    lazy var calenderButton = UIButton()
    
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
        
        self.backgroundColor = .whiteCustom
        
        calendarNavigationView.do {
            $0.backgroundColor = .red
        }
        
        calendarCollectionView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        calenderButton.do {
            $0.makeCornerRound(radius: 10)
            $0.backgroundColor = .grey02
            $0.setAttributedTitle(UIFont.pretendardString(text: "답장 확인", style: .body1_semibold), for: .normal)
            $0.setTitleColor(.whiteCustom, for: .normal)
        }
    }
    
    func setHierarchy() {
        
        self.addSubviews(
            calendarNavigationView,
            calendarCollectionView,
            calenderButton
        )
    }
    
    func setLayout() {
        
        calendarNavigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(calendarNavigationView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        calenderButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(26)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalTo(calendarCollectionView)
            $0.height.equalTo(48)
        }
    }
    
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { (sectionNumber, _ environment) -> NSCollectionLayoutSection? in
            
            let section: NSCollectionLayoutSection
            switch sectionNumber {
            case 0:
                section = self.createCalendarSection()
            default:
                section = self.createDailyCalendarSection()
            }
            return section
        }
    }
    
    func createCalendarSection() -> NSCollectionLayoutSection {
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(421))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(421)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 0)
        
        return section
    }
    
    
    func createDailyCalendarSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(66))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(66)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)

        section.interGroupSpacing = 8
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(54))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        return section
    }
}
