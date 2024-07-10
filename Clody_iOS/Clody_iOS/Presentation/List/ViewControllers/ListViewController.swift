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
    private let tapReplyRelay = PublishRelay<String>()
    private let tapKebobRelay = PublishRelay<String>()
    private let tabMonthRelay = PublishRelay<String>()
    
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
        bindViewModel()
        setStyle()
    }
}

// MARK: - Extensions

private extension ListViewController {
    
    func bindViewModel() {
        let input = ListViewModel.Input(
            viewDidLoad: Observable.just(()),
            tapReplyButton: tapReplyRelay.asSignal(),
            tapKebabButton: tapKebobRelay.asSignal(),
            monthTap: tabMonthRelay.asSignal()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.replyDate
            .drive(onNext: { [weak self] date in
                guard let self = self else { return }
                // 필요한 동작 수행
                print("Reply Date: \(date)")
            })
            .disposed(by: disposeBag)
        
        output.kebabDate
            .drive(onNext: { [weak self] date in
                guard let self = self else { return }
                // 필요한 동작 수행
                print("Kebab Date: \(date)")
            })
            .disposed(by: disposeBag)
    }
    
    func setDelegate() {
        rootView.listCollectionView.dataSource = self
    }
    
    func setStyle() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func registerCells() {
        rootView.listCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.description())
        rootView.listCollectionView.register(ListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ListHeaderView.description())
    }
}

extension ListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.listDummyDataRelay.value.diaries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.listDummyDataRelay.value.diaries[section].diary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.description(), for: indexPath)
                as? ListCollectionViewCell else { return UICollectionViewCell() }
        
        cell.bindData(diaryContent: viewModel.listDummyDataRelay.value.diaries[indexPath.section].diary[indexPath.item], index: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ListHeaderView.description(), for: indexPath) as? ListHeaderView else { return UICollectionReusableView() }
            
            let diaryDate = viewModel.listDummyDataRelay.value.diaries[indexPath.section].date
            
            header.bindData(diary: viewModel.listDummyDataRelay.value.diaries[indexPath.section])
            header.replyButton.rx.tap
                .map { diaryDate }
                .bind(to: tapReplyRelay)
                .disposed(by: disposeBag)
            
            header.kebabButton.rx.tap
                .map { diaryDate }
                .bind(to: tapKebobRelay)
                .disposed(by: disposeBag)
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
