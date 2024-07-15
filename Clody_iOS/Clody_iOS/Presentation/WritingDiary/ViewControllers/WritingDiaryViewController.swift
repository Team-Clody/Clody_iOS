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
import RxDataSources
import SnapKit
import Then

final class WritingDiaryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = WritingDiaryViewModel()
    private let disposeBag = DisposeBag()
    private let kebabButtonTap = PublishRelay<Int>()
    
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
            tapAddButton: rootView.addButton.rx.tap.asSignal(),
            tapBackButton: rootView.navigationBarView.backButton.rx.tap.asSignal(),
            kebabButtonTap: kebabButtonTap
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        let dataSource = configureCollectionView()
        
        output.popToCalendar
            .emit(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.items
            .drive(rootView.writingCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.isAddButtonEnabled
            .drive(onNext: { [weak self] isEnabled in
                if !isEnabled {
                    ClodyToast.show(message: "일기는 5개 까지만 작성할 수 있어요.")
                }
                let image = isEnabled ? "addButton" : "addButtonOff"
                self?.rootView.addButton.setImage(UIImage(named: image), for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.showSaveErrorToast
            .emit(onNext: {
                ClodyToast.show(message: "모든 감사 일기 작성이 필요해요.")
            })
            .disposed(by: disposeBag)
        
        output.showSaveAlert
            .emit(onNext: {
                self.showClodyAlert(type: .saveDiary, title: "일기를 저장할까요?", message: "저장한 일기는 수정이 어려워요.", rightButtonText: "저장하기")
            })
            .disposed(by: disposeBag)
    }
    
    func setStyle() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func registerCells() {
        rootView.writingCollectionView.register(WritingDiaryCell.self, forCellWithReuseIdentifier: WritingDiaryCell.description())
        rootView.writingCollectionView.register(WritingDiaryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WritingDiaryHeaderView.description())
    }
    
    func configureCollectionView() -> RxCollectionViewSectionedReloadDataSource<WritingDiarySection> {
        return RxCollectionViewSectionedReloadDataSource<WritingDiarySection>(
            configureCell: { [weak self] dataSource, collectionView, indexPath, text in
                guard let self = self else { return UICollectionViewCell() }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WritingDiaryCell.description(), for: indexPath) as! WritingDiaryCell
                
                cell.bindData(
                    index: indexPath.item + 1,
                    text: text,
                    statuses: self.viewModel.textViewIsEmptyRelay.value[indexPath.row],
                    isFirst: self.viewModel.isFirstRelay.value[indexPath.row]
                )
                
                cell.kebabButton.rx.tap
                    .map { indexPath.row }
                    .bind(to: self.kebabButtonTap)
                    .disposed(by: cell.disposeBag)
                
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
                        
                        var isFirst = self.viewModel.isFirstRelay.value
                        isFirst[indexPath.item] = false
                        self.viewModel.isFirstRelay.accept(isFirst)
                        cell.writingListNumberLabel.textColor = .grey02
                        cell.textView.textColor = .grey03
                        
                        cell.textView.rx.text.orEmpty
                            .map { "\($0.count)" }
                            .bind(to: cell.textInputLabel.rx.text)
                            .disposed(by: cell.disposeBag)
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.textView.rx.didEndEditing
                    .subscribe(onNext: { [weak cell] in
                        guard let cell = cell else { return }
                        var status = self.viewModel.textViewIsEmptyRelay.value
                        status[indexPath.item] = !cell.textView.text.isEmpty
                        self.viewModel.textViewIsEmptyRelay.accept(status)
                        
                        var items = self.viewModel.diariesRelay.value
                        items[indexPath.item] = cell.textView.text
                        self.viewModel.diariesRelay.accept(items)
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WritingDiaryHeaderView.description(), for: indexPath) as! WritingDiaryHeaderView
                header.bindData(date: "6월 26일 목요일")
                return header
            }
        )
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
