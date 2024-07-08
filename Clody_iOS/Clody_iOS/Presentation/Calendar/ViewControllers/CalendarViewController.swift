//
//  CalendarViewController.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/28/24.
//

import UIKit

import FSCalendar
import RxCocoa
import RxSwift
import SnapKit
import Then

final class CalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = CalendarViewModel()
    private let disposeBag = DisposeBag()
    
    private let tapDateRelay = PublishRelay<Date>()
    private let currentPageRelay = PublishRelay<Date>()
    
    // MARK: - UI Components
    
    private let rootView = CalendarView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setUI()
        setAddTarget()
        registerCells()
        setDelegate()
    }
}

// MARK: - Extensions

private extension CalendarViewController {
    
    func bindViewModel() {
        let input = CalendarViewModel.Input(
            viewDidLoad: Observable.just(()),
            tapDateCell: tapDateRelay.asSignal(),
            tapResponseButton: rootView.calenderButton.rx.tap.asSignal(),
            currentPageChanged: currentPageRelay.asSignal()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.dateLabel
            .drive(onNext: { [weak self] dateString in
                guard let self = self else { return }
                if let header = self.rootView.calendarCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 1)) as? DailyCalendarHeaderView {
                    header.setDate(date: dateString)
                }
            })
            .disposed(by: disposeBag)
        
        output.selectedDate
            .drive(onNext: { [weak self] dateString in
                self?.rootView.calendarCollectionView.reloadData()
                }
            )
            .disposed(by: disposeBag)
        
        output.responseButtonStatus
            .drive(onNext: { status in
                print("Response Button Status: \(status)")
            })
            .disposed(by: disposeBag)
        
        rootView.calenderButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.responseButtonStatusRelay.accept(self?.viewModel.dailyDiaryDummyDataRelay.value.status ?? "")
            }
            .disposed(by: disposeBag)
    }

    func setUI() { // 탭바, 내비바, 그외 ...
    }
    
    func setDelegate() {
        rootView.calendarCollectionView.dataSource = self
    }
    
    func setAddTarget() {
    }
    
    func registerCells() {
        rootView.calendarCollectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.description())
        rootView.calendarCollectionView.register(DailyCalendarCollectionViewCell.self, forCellWithReuseIdentifier: DailyCalendarCollectionViewCell.description())
        
        rootView.calendarCollectionView.register(DailyCalendarHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DailyCalendarHeaderView.description())
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1:
            return viewModel.dailyDiaryDummyDataRelay.value.diary.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.description(), for: indexPath)
                    as? CalendarCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configure(data: viewModel.calendarDummyDataRelay.value)
            cell.dateSelected = { [weak self] date in
                self?.tapDateRelay.accept(date)
            }
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCalendarCollectionViewCell.description(), for: indexPath)
                    as? DailyCalendarCollectionViewCell else { return UICollectionViewCell() }
            
            print(indexPath.item)
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch indexPath.section {
            case 1:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DailyCalendarHeaderView.description(), for: indexPath) as? DailyCalendarHeaderView else { return UICollectionReusableView() }

                return header
                
            default:
                return UICollectionReusableView()
            }
            
        default:
            return UICollectionReusableView()
        }
    }
    
}


