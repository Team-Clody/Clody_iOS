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
        let input = WritingDiaryViewModel.Input(
            viewDidLoad: Observable.just(()),
            tapSaveButton: rootView.saveButton.rx.tap.asSignal(),
            tapAddButton: rootView.addButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.items
            .drive(rootView.writingCollectionView.rx.items(cellIdentifier: WritingDiaryCell.description(), cellType: WritingDiaryCell.self)) { index, text, cell in
                
                cell.bindData(index: index + 1, text: text, statuses: self.viewModel.textViewStatusRelay.value[index])
                
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
                    .subscribe(onNext: {
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
                    .subscribe(onNext: { [weak cell] in
                        guard let cell = cell else { return }
                        // itemsRelay에 추가
                        var status = self.viewModel.textViewStatusRelay.value
                        status[index] = !cell.textView.text.isEmpty
                        self.viewModel.textViewStatusRelay.accept(status)
                        
                        var items = self.viewModel.itemsRelay.value
                        items[index] = cell.textView.text
                        self.viewModel.itemsRelay.accept(items)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    func setDelegate() {
        
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
