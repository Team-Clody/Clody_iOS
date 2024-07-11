//
//  WritingDiaryViewControllers.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import RxCocoa
import RxSwift
import RxKeyboard
import RxGesture
import SnapKit
import Then

final class WritingDiaryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = WritingDiaryViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let rootView = WritingDiaryView()
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
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
        setupGestureRecognizer()
        setupKeyboardHandling()
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
        
        output.items
            .drive(onNext: { [weak self] item in
                print(item)
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
    
    func setupGestureRecognizer() {
        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.rx.event
            .bind { [weak self] _ in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
    
    func setupKeyboardHandling() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                let addButtonPadding = keyboardVisibleHeight > 0 ? keyboardVisibleHeight - self.view.safeAreaInsets.bottom + 20 : 76
                self.rootView.addButton.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(addButtonPadding)
                }
                
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
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
        
        let tapGesture = UITapGestureRecognizer()
        cell.writingContainer.addGestureRecognizer(tapGesture)
        
        cell.bindData(index: indexPath.item + 1, text: viewModel.itemsRelay.value[indexPath.item])
        
        cell.writingContainer.rx.tapGesture()
             .when(.recognized)
             .subscribe(onNext: { [weak cell] _ in
                 cell?.textView.becomeFirstResponder()
             })
             .disposed(by: cell.disposeBag)
        
        cell.textView.rx.text.orEmpty
            .skip(1)
            .map { String($0.prefix(50)) }
            .bind(to: cell.textView.rx.text)
            .disposed(by: cell.disposeBag)
        
        cell.textView.rx.didBeginEditing
            .subscribe(onNext: { [weak cell] in
                guard let cell = cell else { return }
                cell.writingContainer.makeBorder(width: 1, color: .mainYellow)
                if cell.textView.text == "일상 속 작은 감사함을 적어보세요." {
                    cell.textView.text = ""
                }
                cell.textView.rx.text.orEmpty
                    .map { "\($0.count)" }
                    .bind(to: cell.textInputLabel.rx.text)
                    .disposed(by: cell.disposeBag)
            })
            .disposed(by: cell.disposeBag)
        
        cell.textView.rx.didEndEditing
            .map { cell.textView.text ?? "" }
            .bind(to: viewModel.textEndEditing)
            .disposed(by: cell.disposeBag)
        
        cell.textView.rx.didEndEditing
            .subscribe(onNext: { [weak cell] in
                guard let cell = cell else { return }
                // itemsRelay에 추가
                var items = self.viewModel.itemsRelay.value
                items.append(cell.textView.text)
                self.viewModel.itemsRelay.accept(items)
                
                if cell.textView.text.isEmpty {
                    cell.writingContainer.makeBorder(width: 1, color: .red)
                    cell.textInputLabel.text = "0"
                    cell.textView.text = "일상 속 작은 감사함을 적어보세요."
                } else {
                    cell.writingContainer.makeBorder(width: 0, color: .clear)
                }
            })
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
