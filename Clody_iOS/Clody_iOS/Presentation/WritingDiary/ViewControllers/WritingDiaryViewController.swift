//
//  WritingDiaryViewControllers.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class WritingDiaryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = WritingDiaryViewModel()
    private let disposeBag = DisposeBag()
    private let tapReplyRelay = PublishRelay<String>()
    private let tapKebobRelay = PublishRelay<String>()
    private let tabMonthRelay = PublishRelay<String>()
    
    // MARK: - UI Components
    
    private let rootView = WritingDiaryView()
    
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

private extension WritingDiaryViewController {
    
    func bindViewModel() {
        let input = WritingDiaryViewModel.Input(
            viewDidLoad: Observable.just(()),
            tapReplyButton: tapReplyRelay.asSignal(),
            tapKebabButton: tapKebobRelay.asSignal(),
            monthTap: tabMonthRelay.asSignal()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.diaryData
            .drive(rootView.dailyDiaryCollectionView.rx.items(cellIdentifier: WritingDiaryCell.description(), cellType: WritingDiaryCell.self)) { index, model, cell in
//                cell.bindData(data: model, index: "\(index + 1).")
            }
            .disposed(by: disposeBag)
    }
    
    func setDelegate() {
        rootView.writingCollectionView.dataSource = self
    }
    
    func setStyle() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func registerCells() {
        rootView.writingCollectionView.register(WritingDiaryCell.self, forCellWithReuseIdentifier: WritingDiaryCell.description())
        rootView.writingCollectionView.register(WritingDiaryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WritingDiaryHeaderView.description())
    }
}

extension WritingDiaryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
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
