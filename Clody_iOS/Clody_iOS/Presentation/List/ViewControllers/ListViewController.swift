//
//  ListViewController.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import FSCalendar
import RxCocoa
import RxSwift
import SnapKit
import Then

final class ListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = ListViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let rootView = ListView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                registerCells()
                setDelegate()
//                bindViewModel()
                setStyle()
    }
}

// MARK: - Extensions

private extension ListViewController {
    
    //    func bindViewModel() {
    //        let input = CalendarViewModel.Input(
    //            viewDidLoad: Observable.just(()),
    //            tapDateCell: tapDateRelay.asSignal(),
    //            tapResponseButton: rootView.calendarButton.rx.tap.asSignal(),
    //            currentPageChanged: currentPageRelay.asSignal()
    //        )
    //
    //        let output = viewModel.transform(from: input, disposeBag: disposeBag)
    //
    //        output.dateLabel
    //            .drive(rootView.dateLabel.rx.text)
    //            .disposed(by: disposeBag)
    //
    //        output.diaryData
    //            .drive(rootView.dailyDiaryCollectionView.rx.items(cellIdentifier: DailyCalendarCollectionViewCell.description(), cellType: DailyCalendarCollectionViewCell.self)) { index, model, cell in
    //                cell.bindData(data: model, index: "\(index + 1).")
    //            }
    //            .disposed(by: disposeBag)
    //
    //        output.responseButtonStatus
    //            .drive(onNext: { status in
    //                print("Status: \(status)")
    //                // 이후 status에 따른 분기 처리
    //            })
    //            .disposed(by: disposeBag)
    //
    //        output.calendarData
    //            .drive(onNext: { [weak self] data in
    //                guard let self = self else { return }
    //                self.calendarData = data
    //            })
    //            .disposed(by: disposeBag)
    //
    //        output.selectedDate
    //            .drive(onNext: { [weak self] data in
    //                guard let self = self else { return }
    //                self.rootView.calendarView.reloadData()
    //
    //            })
    //            .disposed(by: disposeBag)
    //
    //        rootView.calendarButton.rx.tap
    //            .bind { [weak self] in
    //                self?.viewModel.responseButtonStatusRelay.accept(self?.viewModel.dailyDiaryDummyDataRelay.value.status ?? "")
    //            }
    //            .disposed(by: disposeBag)
    //    }
    
    func setDelegate() {
        rootView.listCollectionView.dataSource = self
    }
    
    func setStyle() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func registerCells() {
        rootView.listCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.description())
        rootView.listCollectionView.register(ListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ListHeaderView.description())
        
//        rootView.listCollectionView.register(ListBackgroundView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ListBackgroundView.description())
        
    }
}


extension ListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 3
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.description(), for: indexPath)
                as? ListCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ListHeaderView.description(), for: indexPath) as? ListHeaderView else { return UICollectionReusableView() }
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
}
