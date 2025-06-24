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
    private let kebabButtonTap = PublishRelay<Int>()
    private let date: Date
    private let isFromDraft: Bool
    private var textViewHeight: CGFloat = 0
    private var currentKeyboardVisible: Bool = false
    private var isAddButtonEnabled: Bool = true
    private let firstDraftSaveCompletion: (() -> Void)?
    
    // MARK: - UI Components
    
    private let rootView = WritingDiaryView()
    private let deleteBottomSheetView = DeleteBottomSheetView()
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private var alert: ClodyAlert?
    private lazy var dimmingView = UIView()
    
    // MARK: - Life Cycles
    
    init(
        date: Date,
        isFromDraft: Bool,
        firstDraftSaveCompletion: (() -> Void)? = nil
    ) {
        self.date = date
        self.isFromDraft = isFromDraft
        self.firstDraftSaveCompletion = firstDraftSaveCompletion
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        setupDeleteBottomSheet()
        configureHeader()
        configureDraft()
    }
}

// MARK: - Extensions

private extension WritingDiaryViewController {
    
    func bindViewModel() {
        let input = WritingDiaryViewModel.Input(
            tapSubmitButton: rootView.headerView.submitButton.rx.tap
                .do(onNext: { [weak self] in
                    self?.view.endEditing(true)
                })
                .asSignal(onErrorJustReturn: ()),
            tapAddButton: rootView.addButton.rx.tap.asSignal(),
            tapBackButton: rootView.headerView.backButton.rx.tap.asSignal(),
            updateKebobRelay: kebabButtonTap,
            tapDeleteButton: deleteBottomSheetView.bottomSheetView.rx.tapGesture()
                .when(.recognized)
                .map { _ in }
                .asSignal(onErrorJustReturn: ()),
            tapHelpInfoButton: rootView.headerView.infoButton.rx.tap.asSignal(),
            tapCancelButton: rootView.headerView.cancelHelpButton.rx.tapGesture()
                .when(.recognized)
                .map { _ in }
                .asSignal(onErrorJustReturn: ())
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.diaryItems
            .drive(rootView.writingCollectionView.rx.items(
                cellIdentifier: WritingDiaryCell.description(),
                cellType: WritingDiaryCell.self
            )) { [weak self] index, item, cell in
                guard let self = self else { return }
                
                cell.bindData(index: index, item: item)
                
                cell.kebabButton.rx.tap
                    .map { index }
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
                    .distinctUntilChanged()
                    .do(onNext: { [weak cell] text in
                        guard let cell = cell else { return }
                        
                        let limitedText = String(text.prefix(50))
                        if cell.textView.text != limitedText {
                            cell.textView.text = limitedText
                        }

                        cell.textInputLabel.text = "\(limitedText.count)"

                        let isValid = limitedText.count < 50
                        cell.limitErrorLabel.isHidden = isValid
                        cell.writingContainer.makeBorder(
                            width: 1,
                            color: isValid ? .mainYellow : .redCustom
                        )
                    })
                    .subscribe(onNext: { [weak self, weak cell] _ in
                        guard let self = self, let cell = cell else { return }
                        var state = viewModel.currentBufferState
                        state.updateItem(at: index, text: cell.textView.text)
                        viewModel.updateTextBuffer(state)
                        updateTextViewHeightIfNeeded(for: cell, rootView.writingCollectionView)
                    })
                    .disposed(by: cell.disposeBag)

                cell.textView.rx.didBeginEditing
                    .subscribe(onNext: { [weak cell] in
                        guard let cell = cell else { return }
                        cell.updateUIOnBeginEditing()
                    })
                    .disposed(by: cell.disposeBag)

                cell.textView.rx.didEndEditing
                    .subscribe(onNext: { [weak cell] in
                        guard let cell = cell else { return }
                        let updatedItem = DiaryItem(text: cell.textView.text, isPlaceholder: false)
                        cell.bindData(index: index, item: updatedItem)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.isAddButtonEnabled
            .drive(onNext: { [weak self] isEnabled in
                guard let self = self else { return }
                isAddButtonEnabled = isEnabled
                
                let buttonImage: UIImage = currentKeyboardVisible
                ? (isEnabled ? .smallAddButton : .smallAddButtonOff)
                : (isEnabled ? .bigAddButton : .bigAddButtonOff)
                self.rootView.addButton.setImage(buttonImage, for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.showSubmitErrorToast
            .emit(onNext: {
                ClodyToast.show(toastType: .needToWriteAll)
            })
            .disposed(by: disposeBag)
        
        output.showLimitFiveErrorToast
            .emit(onNext: {
                ClodyToast.show(toastType: .limitFive)
            })
            .disposed(by: disposeBag)
        
        output.showDelete
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                view.endEditing(true)
                presentBottomSheet()
            })
            .disposed(by: disposeBag)
        
        output.showSubmitAlert
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                
                showAlert(
                    type: .saveDiary,
                    title: I18N.Alert.submitDiaryTitle,
                    message: I18N.Alert.submitDiaryMessage,
                    rightButtonText: I18N.Alert.submit
                )
                
                alert?.leftButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        self?.hideAlert()
                        AmplitudeManager.shared.trackEvent("writing_diary_no_complete")
                    })
                    .disposed(by: disposeBag)
                
                alert?.rightButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        AmplitudeManager.shared.trackEvent("writing_diary_complete")
                        showLoadingIndicator()
                        let dateString = DateFormatter.string(from: date, format: "yyyy-MM-dd")
                        
                        viewModel.postDiary(
                            date: dateString,
                            content: viewModel.getCurrentTexts()
                        ) { [weak self] statusCode, type, isFromDraft in
                            guard let self = self else { return }
                            hideLoadingIndicator()
                            
                            switch statusCode {
                            case .success:
                                let isWritingUnavailable = !date.isWritingAvailable
                                
                                if type == "DELETED" || isWritingUnavailable {
                                    navigationController?.popViewController(animated: true)
                                } else {
                                    navigationController?.pushViewController(ReplyWaitingViewController(date: date, isHomeBackButton: true), animated: true)
                                }
                            case .network:
                                showErrorAlert(isNetworkError: true)
                            case .unknowned:
                                showErrorAlert(isNetworkError: false)
                            }
                        }
                        
                        hideAlert()
                    })
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        
        output.showDraftAlert
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                view.endEditing(true)
                viewModel.updateDiaryState()
                
                if !viewModel.hasAnyContent() {
                    navigationController?.popViewController(animated: true)
                    return
                }
                
                showAlert(
                    type: .draftDiary,
                    title: I18N.Alert.draftTitle,
                    message: I18N.Alert.draftMessage,
                    rightButtonText: I18N.Alert.back
                )
                
                alert?.rightButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        self?.hideAlert()
                        self?.navigationController?.popViewController(animated: true)
                        AmplitudeManager.shared.trackEvent("writing_diary_back")
                    })
                    .disposed(by: disposeBag)
                
                alert?.leftButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        
                        if !viewModel.hasAnyContent() {
                            ClodyToast.show(toastType: .needToWriteAll)
                            hideAlert()
                            return
                        }
                        
                        showLoadingIndicator()
                        let dateString = DateFormatter.string(from: date, format: "yyyy-MM-dd")
                        
                        viewModel.postDraftDiary(
                            date: dateString,
                            content: viewModel.getCurrentTexts()
                        ) { [weak self] statusCode, type in
                            guard let self = self else { return }
                            hideLoadingIndicator()
                            
                            switch statusCode {
                            case .success:
                                navigationController?.popViewController(animated: true)
                                AmplitudeManager.shared.trackEvent("writing_diary_back")
                                firstDraftSaveCompletion?()
                            case .network:
                                showErrorAlert(isNetworkError: true)
                            case .unknowned:
                                showErrorAlert(isNetworkError: false)
                            }
                        }
                        
                        hideAlert()
                    })
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        
        output.showHelp
            .drive(onNext: { [weak self] isHidden in
                self?.rootView.headerView.helpMessageContainer.isHidden = isHidden
                self?.rootView.headerView.helpMessageDownArrowImage.isHidden = isHidden
            })
            .disposed(by: disposeBag)
    }
    
    func setStyle() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func registerCells() {
        rootView.writingCollectionView.register(WritingDiaryCell.self, forCellWithReuseIdentifier: WritingDiaryCell.description())
    }
    
    func configureHeader() {
        rootView.headerView.bindData(dateData: self.date)
    }
    
    func configureDraft() {
        if isFromDraft { self.viewModel.fetchData(date: self.date) }
    }
    
    private func updateTextViewHeightIfNeeded(for cell: WritingDiaryCell, _ collectionView: UICollectionView) {
        let size = CGSize(width: cell.textView.frame.width, height: .infinity)
        let estimatedSize = cell.textView.sizeThatFits(size)
        
        /// UITextView 높이가 바뀌었을 때만 제약조건을 변경하고, 컬렉션뷰 고유 사이즈를 재계산합니다.
        if textViewHeight != estimatedSize.height {
            cell.textView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                    cell.invalidateIntrinsicContentSize()
                    collectionView.invalidateIntrinsicContentSize()
                }
            }
            textViewHeight = estimatedSize.height
        }
    }
    
    private func setupDeleteBottomSheet() {
        self.view.addSubview(deleteBottomSheetView)
        deleteBottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        deleteBottomSheetView.isHidden = true
        
        deleteBottomSheetView.bottomSheetView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismissBottomSheet(animated: true, completion: {
                    
                })
            })
            .disposed(by: disposeBag)
        
        deleteBottomSheetView.dimmedView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismissBottomSheet(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func presentBottomSheet() {
        deleteBottomSheetView.isHidden = false
        deleteBottomSheetView.dimmedView.alpha = 0.0
        deleteBottomSheetView.animateShow()
    }
    
    private func dismissBottomSheet(animated: Bool, completion: (() -> Void)?) {
        deleteBottomSheetView.animateHide {
            self.deleteBottomSheetView.isHidden = true
            completion?()
        }
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
            .skip(1)
            .distinctUntilChanged()
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                let isKeyboardVisible = keyboardVisibleHeight > 0
                currentKeyboardVisible = isKeyboardVisible
                
                let addButtonPadding = isKeyboardVisible
                ? keyboardVisibleHeight - self.view.safeAreaInsets.bottom + ScreenUtils.getHeight(20)
                : ScreenUtils.getHeight(6)
                
                rootView.addButton.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(addButtonPadding)
                    $0.height.equalTo(ScreenUtils.getHeight(isKeyboardVisible ? 48 : 42))
                }
                
                rootView.writingCollectionView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(isKeyboardVisible ? keyboardVisibleHeight : 0)
                }
                
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
                
                let isEnabled = isAddButtonEnabled
                let image: UIImage = isKeyboardVisible
                ? (isEnabled ? .smallAddButton : .smallAddButtonOff)
                : (isEnabled ? .bigAddButton : .bigAddButtonOff)
                self.rootView.addButton.setImage(image, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}

/// Alert 관련 함수입니다.
private extension WritingDiaryViewController {
    
    func showAlert(
        type: AlertType,
        title: String,
        message: String,
        rightButtonText: String
    ) {
        self.alert = ClodyAlert(type: type, title: title, message: message, rightButtonText: rightButtonText)
        setAlert()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.alert!.alpha = 1
        })
    }
    
    func hideAlert() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alert!.alpha = 0
        }) { _ in
            self.dimmingView.removeFromSuperview()
            self.alert!.removeFromSuperview()
        }
    }
    
    func setAlert() {
        alert!.alpha = 0
        dimmingView.backgroundColor = .black.withAlphaComponent(0.4)
        self.view.addSubviews(dimmingView, alert!)
        
        dimmingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alert!.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.center.equalToSuperview()
        }
    }
}
