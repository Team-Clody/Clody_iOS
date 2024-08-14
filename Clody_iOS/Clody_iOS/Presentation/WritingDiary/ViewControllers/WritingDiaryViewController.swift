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
    private var date: Date
    
    // MARK: - UI Components
    
    private let rootView = WritingDiaryView()
    private let deleteBottomSheetView = DeleteBottomSheetView()
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private var alert: ClodyAlert?
    private lazy var dimmingView = UIView()
    private let alertView = ClodyErrorAlertView()
    
    // MARK: - Life Cycles
    
    init(date: Date) {
        self.date = date
        
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
            updateKebobRelay: kebabButtonTap,
            tapDeleteButton: deleteBottomSheetView.deleteContainer.rx.tapGesture()
                .when(.recognized)
                .map { _ in }
                .asSignal(onErrorJustReturn: ()),
            tapHelpInfoButton: rootView.headerView.infoButton.rx.tap.asSignal(),
            tapCancelButton: rootView.headerView.cancelHelpButton.rx.tap.asSignal()
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
                    ClodyToast.show(toastType: .limitFive)
                }
                let image = isEnabled ? "addButton" : "addButtonOff"
                self?.rootView.addButton.setImage(UIImage(named: image), for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.showSaveErrorToast
            .emit(onNext: {
                ClodyToast.show(toastType: .needToWriteAll)
            })
            .disposed(by: disposeBag)
        
        output.showDelete
            .emit(onNext: {
                self.presentBottomSheet()
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        output.showSaveAlert
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.showAlert(
                    type: .logout,
                    title: I18N.Alert.saveDiaryTitle,
                    message: I18N.Alert.saveDiaryMessage,
                    rightButtonText: I18N.Alert.save
                )
                
                self.alert?.leftButton.rx.tap
                    .subscribe(onNext: {
                        self.hideAlert()
                    })
                    .disposed(by: self.disposeBag)
                
                self.alert?.rightButton.rx.tap
                    .subscribe(onNext: {
                        self.showLoadingIndicator()
                        let dateString = DateFormatter.string(
                            from: self.date,
                            format: "yyyy-MM-dd"
                        )
                        self.viewModel.postDiary(date: dateString, content: self.viewModel.diariesRelay.value, completion: {status in
                            self.hideLoadingIndicator()
                            switch status {
                            case .success:
                                self.navigationController?.pushViewController(ReplyWaitingViewController(date: self.date, isNew: true, isHomeBackButton: true), animated: true)
                            case .network:
                                self.showErrorAlert(isNetworkError: true)
                            case .unKnowned:
                                self.showErrorAlert(isNetworkError: false)
                            }
                        })
                        
                        self.hideAlert()
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        output.showHelp
            .drive(onNext: { [weak self] isHidden in
                self?.rootView.headerView.helpMessageImage.isHidden = isHidden
            })
            .disposed(by: disposeBag)
    }
    
    func setStyle() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func registerCells() {
        rootView.writingCollectionView.register(WritingDiaryCell.self, forCellWithReuseIdentifier: WritingDiaryCell.description())
    }
    
    func configureHeader() {
        rootView.headerView.bindData(dateData: self.date)
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
            }
        )
    }
    
    private func setupDeleteBottomSheet() {
        self.view.addSubview(deleteBottomSheetView)
        deleteBottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        deleteBottomSheetView.isHidden = true
        
        deleteBottomSheetView.deleteContainer.rx.tapGesture()
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
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                let addButtonPadding = keyboardVisibleHeight > 0 ? keyboardVisibleHeight - self.view.safeAreaInsets.bottom + 20 : 76
                self.rootView.addButton.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(addButtonPadding)
                }
                
                self.rootView.writingCollectionView.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(addButtonPadding)
                }
                
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    private func showLoadingIndicator() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        rootView.dimView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        rootView.loadingIndicator.startAnimating()
        rootView.loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubviews(rootView.dimView, rootView.loadingIndicator)
        rootView.dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        rootView.loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func hideLoadingIndicator() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            
        rootView.loadingIndicator.stopAnimating()
        rootView.loadingIndicator.removeFromSuperview()
        rootView.dimView.removeFromSuperview()
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
    
    func showErrorAlert(isNetworkError: Bool) {
        
        if isNetworkError {
            alertView.titleLabel.attributedText = UIFont.pretendardString(
                text: I18N.Error.network,
                style: .body3_medium,
                lineHeightMultiple: 1.5
            )
        } else {
            alertView.titleLabel.attributedText = UIFont.pretendardString(
                text: I18N.Error.unKnown,
                style: .body3_medium,
                lineHeightMultiple: 1.5
            )
        }
        
        self.view.addSubview(alertView)
        
        alertView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
