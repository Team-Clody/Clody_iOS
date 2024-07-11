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
        let textDidEditingRelay = PublishRelay<String>()
        let textEndEditingRelay = PublishRelay<String>()
         
         let input = WritingDiaryViewModel.Input(
             viewDidLoad: Observable.just(()),
             tapSaveButton: rootView.saveButton.rx.tap.asSignal(),
             tapAddButton: rootView.addButton.rx.tap.asSignal(),
             textDidEditing: textDidEditingRelay,
             textEndEditing: textEndEditingRelay
         )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.addItem
            .drive(onNext: { [weak self] itemCount in
                self?.rootView.writingCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.setTextViewStatus
            .drive(onNext: { [weak self] isValid in
                // 유효성 검사에 따른 UI 업데이트 (예: 경계 색상 변경)
            })
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
        return viewModel.itemsRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UICollectionViewFlowLayout.automaticSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WritingDiaryCell.description(), for: indexPath)
                as? WritingDiaryCell else { return UICollectionViewCell() }
        
        cell.textView.rx.text.orEmpty
            .skip(1)
            .bind(to: viewModel.textDidEditing)
            .disposed(by: cell.disposeBag)
        
        cell.textView.rx.didEndEditing
            .map { cell.textView.text ?? "" }
            .bind(to: viewModel.textEndEditing)
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WritingDiaryHeaderView.description(), for: indexPath) as? WritingDiaryHeaderView else { return UICollectionReusableView() }
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
