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
    private let tabMonthRelay = PublishRelay<String>()
    
    // MARK: - UI Components
    
    private let rootView = ListView()
    private let datePickerView = DatePickeView()
    private let deleteBottomSheetView = DeleteBottomSheetView()
    private var alert: ClodyAlert?
    private lazy var dimmingView = UIView()
    
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
            monthTap: tabMonthRelay.asSignal(),
            tapDeleteButton: deleteBottomSheetView.deleteContainer.rx.tapGesture()
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
                let isNew = diaryStatus == "READY_NOT_READ"
                
                self.navigationController?.pushViewController(ReplyWaitingViewController(date: dateData ?? Date(), isNew: isNew, isHomeBackButton: false), animated: true)
            })
            .disposed(by: disposeBag)
        
        output.listDataChanged
            .drive(onNext: { [weak self] date in
                guard let self = self else { return }
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
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showPickerView
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.presentPickerView()
                
                let date = viewModel.selectedMonthRelay.value
                let selectedMonth = "\(date[0])년 \(date[1])월"
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
        
        deleteBottomSheetView.deleteContainer.rx.tapGesture()
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
        
        datePickerView.cancelIcon.rx.tap
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
