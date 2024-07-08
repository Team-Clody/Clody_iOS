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
    
    // MARK: - Properties
    
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
    
    /// View의 Style을 set 합니다.
    func setStyle() {
        calendarNavigationView.do {
            $0.backgroundColor = .red
        }
        
        calendarCollectionView.do {_ in 
            
        }
        
        calenderButton.do {
            $0.makeCornerRound(radius: 10)
            $0.backgroundColor = .grey02
            $0.setAttributedTitle(UIFont.pretendardString(text: "답장 확인", style: .body1_semibold), for: .normal)
            $0.setTitleColor(.whiteCustom, for: .normal)
        }
    }
    /// View의 Hierarchy를 set 합니다.
    func setHierarchy() {
        
        self.addSubviews(
            calendarNavigationView,
            calendarCollectionView,
            calenderButton
        )
    }
    /// View의 Layout을 set 합니다.
    func setLayout() {
        
        calendarNavigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(calendarNavigationView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        calenderButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(26)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(327)
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
        let itemFractionalWidthFraction = 1.0
        let itemInset: CGFloat = 0
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(421))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemInset,
                                                     leading: itemInset,
                                                     bottom: itemInset,
                                                     trailing: itemInset)
        
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(421)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: itemInset,
                                                        leading: itemInset,
                                                        bottom: 6,
                                                        trailing: itemInset)
        
        return section
    }

    
    func createDailyCalendarSection() -> NSCollectionLayoutSection {
           let itemInset: CGFloat = 8
           
           // item
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                 heightDimension: .estimated(66))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           item.contentInsets = NSDirectionalEdgeInsets(top: itemInset,
                                                        leading: itemInset,
                                                        bottom: itemInset,
                                                        trailing: itemInset)
           
           // group
           let groupSize = NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1),
               heightDimension: .estimated(66)
           )
           let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
           
           // section
           let section = NSCollectionLayoutSection(group: group)
           section.contentInsets = NSDirectionalEdgeInsets(top: itemInset,
                                                           leading: itemInset,
                                                           bottom: itemInset,
                                                           trailing: itemInset)
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
