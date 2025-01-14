//
//  ListViewController.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

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
    private let tapMonthRelay = PublishRelay<String>()
    var selectedMonthCompletion: (([String]) -> Void)?
    
    // MARK: - UI Components
    
    private let rootView = ListView()
    private let datePickerView = DatePickerView()
    private let deleteBottomSheetView = DeleteBottomSheetView()
    private var alert: ClodyAlert?
    private lazy var dimmingView = UIView()
    
    // MARK: - Life Cycles
    
    init(month: [String]? = nil) {
        if let month = month {
            viewModel.selectedMonthRelay.accept(month)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
        setContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setDelegate()
        bindViewModel()
        setStyle()
        setupDeleteBottomSheet()
        setupPickerView()
    }
}

// MARK: - Extensions

private extension ListViewController {
    
    func bindViewModel() {
        let input = ListViewModel.Input(
            viewDidLoad: Observable.just(()),
            tapReplyButton: tapReplyRelay.asSignal(),
            tapKebabButton: tapKebobRelay.asSignal(),
            tapCalendarButton: rootView.navigationBarView.calendarButton.rx.tap.asSignal(),
            tapDateButton: rootView.navigationBarView.dateButton.rx.tap.asSignal(),
            monthTap: tapMonthRelay.asSignal(),
            tapDeleteButton: deleteBottomSheetView.bottomSheetView.rx.tapGesture()
                .when(.recognized)
                .map { _ in }
                .asSignal(onErrorJustReturn: ())
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.replyDate
            .drive(onNext: { [weak self] date in
                guard let self = self else { return }
                let dateData = DateFormatter.date(from: date)
                let diaryStatus = viewModel.listDataRelay.value.diaries.first(where: { $0.date == date})?.replyStatus
                
                self.navigationController?.pushViewController(ReplyWaitingViewController(date: dateData ?? Date(), isHomeBackButton: false), animated: true)
            })
            .disposed(by: disposeBag)
        
        output.listDataChanged
            .drive(onNext: { [weak self] date in
                guard let self = self else { return }
                self.setContentView()
                rootView.listCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.kebabDate
            .drive(onNext: { [weak self] date in
                guard let self = self else { return }
                self.presentBottomSheet()
            })
            .disposed(by: disposeBag)
        
        output.changeToCalendar
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                
                popToCalendar()
            })
            .disposed(by: disposeBag)
        
        output.showPickerView
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.presentPickerView()
                
                let date = viewModel.selectedMonthRelay.value
                let year = date[0]
                let month = DateFormatter.convertToDoubleDigitMonth(from: date[1])
                
                let selectedMonth = "\(year)년 \(month ?? "")월"
                rootView.navigationBarView.dateText = selectedMonth
            })
            .disposed(by: disposeBag)
        
        output.changeNavigationDate
            .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                rootView.navigationBarView.dateText = data
            })
            .disposed(by: disposeBag)
        
        output.showDelete
            .emit(onNext: { [weak self] index in
                guard let self = self else { return }
                self.showAlert(
                    type: .deleteDiary,
                    title: I18N.Alert.deleteDiaryTitle,
                    message: I18N.Alert.deleteDiaryMessage,
                    rightButtonText: I18N.Alert.delete
                )
                
                self.alert?.leftButton.rx.tap
                    .subscribe(onNext: {
                        self.hideAlert()
                    })
                    .disposed(by: self.disposeBag)
                
                self.alert?.rightButton.rx.tap
                    .subscribe(onNext: {
                        let dateComponents = self.viewModel.selectedDateRelay.value?.split(separator: "-").map { Int($0) ?? 0 }
                        if dateComponents?.count == 3 {
                            let year = dateComponents?[0]
                            let month = dateComponents?[1]
                            let day = dateComponents?[2]
                            
                            self.viewModel.deleteDiary(year: year ?? 0, month: month ?? 0, date: day ?? 0)
                        }
                        self.hideAlert()
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.showLoadingIndicator()
                } else {
                    self?.hideLoadingIndicator()
                }
            })
            .disposed(by: disposeBag)

        output.errorStatus
            .drive(onNext: { [weak self] errorStatus in
                switch errorStatus {
                case "networkView":
                    self?.showRetryView(isNetworkError: true) {
                        self?.viewModel.fetchData()
                    }
                case "unknownedView":
                    self?.showRetryView(isNetworkError: false) {
                        self?.viewModel.fetchData()
                    }
                default:
                    self?.showErrorAlert(isNetworkError: false)
                }
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
                    //                    self?.showClodyAlert(type: .deleteDiary, title: "정말 일기를 삭제할까요?", message: "아직 답장이 오지 않았거나 삭제하고\n다시 작성한 일기는 답장을 받을 수 없어요.", rightButtonText: "삭제")
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
    
    private func setupPickerView() {
        self.view.addSubview(datePickerView)
        datePickerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        datePickerView.isHidden = true
        
        datePickerView.navigationBar.xButton.rx.tap
            .subscribe(onNext: {
                self.dismissPickerView(animated: true, completion: {
                    
                })
            })
            .disposed(by: self.disposeBag)
        
        datePickerView.completeButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {
                [weak self] _ in
                self?.dismissPickerView(animated: true,
                                        completion: {
                    // 로직
                    let selectedYearIndex = self?.datePickerView.pickerView.selectedRow(inComponent: 0) ?? 0
                    let selectedMonthIndex = self?.datePickerView.pickerView.selectedRow(inComponent: 1) ?? 0
                    
                    guard let selectedYear = self?.datePickerView.pickerView.years[selectedYearIndex] else {
                        return
                    }
                    guard let selectedMonth = self?.datePickerView.pickerView.months[selectedMonthIndex] else {
                        return
                    }
                    
                    let selectedMonthYear = ["\(selectedYear)", "\(selectedMonth)"]
                    self?.viewModel.selectedMonthRelay.accept(selectedMonthYear)
                })
            })
            .disposed(by: disposeBag)
        
        datePickerView.dimmedView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismissPickerView(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func presentBottomSheet() {
        deleteBottomSheetView.isHidden = false
        deleteBottomSheetView.dimmedView.alpha = 0.0
        deleteBottomSheetView.animateShow()
    }
    
    private func presentPickerView() {
        datePickerView.isHidden = false
        datePickerView.dimmedView.alpha = 0.0
        datePickerView.animateShow()
    }
    
    private func dismissBottomSheet(animated: Bool, completion: (() -> Void)?) {
        deleteBottomSheetView.animateHide {
            self.deleteBottomSheetView.isHidden = true
            completion?()
        }
    }
    
    private func dismissPickerView(animated: Bool, completion: (() -> Void)?) {
        datePickerView.animateHide {
            self.datePickerView.isHidden = true
            completion?()
        }
    }
    
    private func setContentView() {
        if viewModel.listDataRelay.value.diaries.isEmpty {
            rootView.listCollectionView.isHidden = true
            rootView.listEmptyView.isHidden = false
        } else {
            rootView.listCollectionView.isHidden = false
            rootView.listEmptyView.isHidden = true
        }
    }
    
    private func popToCalendar() {
        self.navigationController?.popViewController(animated: true)
        let selectedMonth = viewModel.selectedMonthRelay.value
        guard let selectedMonthCompletion else {return}
        selectedMonthCompletion(selectedMonth)
    }
}

extension ListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.listDataRelay.value.diaries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.listDataRelay.value.diaries[section].diary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.description(), for: indexPath)
                as? ListCollectionViewCell else { return UICollectionViewCell() }
        
        cell.bindData(diaryContent: viewModel.listDataRelay.value.diaries[indexPath.section].diary[indexPath.item].content, index: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ListHeaderView.description(), for: indexPath) as? ListHeaderView else { return UICollectionReusableView() }
            
            let diaryDate = viewModel.listDataRelay.value.diaries[indexPath.section].date
            
            header.bindData(diary: viewModel.listDataRelay.value.diaries[indexPath.section])
            header.replyButton.rx.tap
                .map { diaryDate }
                .bind(to: tapReplyRelay)
                .disposed(by: header.cellDisposeBag)
            
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

private extension ListViewController {
    
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
        rootView.listCollectionView.reloadData()
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
