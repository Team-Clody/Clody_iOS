//
//  CalendarViewController.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/28/24.
//

import UIKit

import FSCalendar
import RxCocoa
import RxSwift
import SnapKit
import Then

final class CalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = CalendarViewModel()
    private let disposeBag = DisposeBag()
    
    private let tapDateRelay = PublishRelay<Date>()
    private let currentPageRelay = PublishRelay<Date>()
    private var calendarData: [MonthlyDiary] = [MonthlyDiary(diaryCount: 0, replyStatus: "")]
    
    // MARK: - UI Components
    
    private var rootView = CalendarView()
    private let deleteBottomSheetView = DeleteBottomSheetView()
    private let datePickerView = DatePickeView()
    
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

private extension CalendarViewController {
    
    func bindViewModel() {
        let input = CalendarViewModel.Input(
            viewDidLoad: Observable.just(()),
            tapDateCell: tapDateRelay.asSignal(),
            tapResponseButton: rootView.calendarButton.rx.tap.asSignal(),
            tapListButton: rootView.calendarNavigationView.listButton.rx.tap.asSignal(),
            tapSettingButton: rootView.calendarNavigationView.settingButton.rx.tap.asSignal(),
            currentPageChanged: currentPageRelay.asSignal(),
            tapKebabButton:  rootView.kebabButton.rx.tap.asSignal(),
            tapDateButton: rootView.calendarNavigationView.dateButton.rx.tap.asSignal(),
            tapDeleteButton: deleteBottomSheetView.deleteContainer.rx.tapGesture()
                .when(.recognized)
                .map { _ in }
                .asSignal(onErrorJustReturn: ())
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.dateLabel
            .drive(rootView.dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        //데일리 다이어리 업데이트
        output.diaryData
            .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                let isNotEmpty = data.count != 0
                let isToday = Calendar.current.isDateInToday(self.viewModel.selectedDateRelay.value)
                
                var buttonTitle = isNotEmpty ? "답장 확인" : "일기 쓰기"
                var buttonColor = isNotEmpty ? UIColor(named: "grey01") : UIColor(named: "mainYellow")
                var textColor = isNotEmpty ? "white" : "grey02"
                let isEnabled = isToday || isNotEmpty
                
                if !isEnabled {
                    buttonColor = .lightYellow
                    textColor = "grey06"
                }
                
                self.rootView.emptyDiaryView.isHidden = isNotEmpty
                self.rootView.calendarButton.setAttributedTitle(UIFont.pretendardString(text: buttonTitle, style: .body1_semibold), for: .normal)
                self.rootView.calendarButton.backgroundColor = buttonColor
                self.rootView.calendarButton.setTitleColor(UIColor(named: textColor), for: .normal)
                self.rootView.calendarButton.isEnabled = isEnabled
            })
            .disposed(by: disposeBag)
        
        output.diaryData
            .drive(rootView.dailyDiaryCollectionView.rx.items(cellIdentifier: DailyCalendarCollectionViewCell.description(), cellType: DailyCalendarCollectionViewCell.self)) { index, model, cell in
                cell.bindData(data: model.content, index: "\(index + 1).")
            }
            .disposed(by: disposeBag)
        
        // count와 reply를 담고 있는 배열
        output.calendarData
            .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                self.calendarData = data
            })
            .disposed(by: disposeBag)
        
        output.selectedDate
            .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                rootView.mainCalendarView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.changeToList
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                let listViewController = ListViewController()
                self.navigationController?.pushViewController(listViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.changeToSetting
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                let myPageViewController = MyPageViewController()
                self.navigationController?.pushViewController(myPageViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showDeleteBottomSheet
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.presentBottomSheet()
            })
            .disposed(by: disposeBag)
        
        output.showPickerView
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.presentPickerView()
            })
            .disposed(by: disposeBag)
        
        output.changeNavigationDate
            .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                rootView.calendarNavigationView.dateButton.titleLabel?.text = data
            })
            .disposed(by: disposeBag)
        
        output.cloverCount
            .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                rootView.cloverLabel.text = "클로버 \(data)개"
            })
            .disposed(by: disposeBag)
        
        output.navigateToResponse
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                if viewModel.dailyDiaryDataRelay.value.diaries.count != 0 {
                    self.navigationController?.pushViewController(ReplyWaitingViewController(), animated: true)
                } else {
                    self.navigationController?.pushViewController(WritingDiaryViewController(), animated: true)
                }
            })
            .disposed(by: disposeBag)
        
//        rootView.calendarButton.rx.tap
//            .bind { [weak self] in
//                //                self?.viewModel.responseButtonStatusRelay.accept(self?.viewModel.dailyDiaryDummyDataRelay.value.status ?? "")
//            }
//            .disposed(by: disposeBag)
        
        output.diaryDeleted
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                // 필요한 후처리
            })
            .disposed(by: disposeBag)
    }
    
    func setDelegate() {
        rootView.mainCalendarView.delegate = self
        rootView.mainCalendarView.dataSource = self
    }
    
    func setStyle() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func registerCells() {
        rootView.mainCalendarView.register(CalendarDateCell.self, forCellReuseIdentifier: CalendarDateCell.description())
        rootView.dailyDiaryCollectionView.register(DailyCalendarCollectionViewCell.self, forCellWithReuseIdentifier: DailyCalendarCollectionViewCell.description())
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
                    self?.showClodyAlert(type: .deleteDiary, title: "정말 일기를 삭제할까요?", message: "아직 답장이 오지 않았거나 삭제하고\n다시 작성한 일기는 답장을 받을 수 없어요.", rightButtonText: "삭제")
                    
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
                    
                    var dateComponents = DateComponents()
                    dateComponents.year = selectedYear
                    dateComponents.month = selectedMonth
                    dateComponents.day = 1 // 해당 월의 첫 번째 날로 설정
                    
                    if let date = Calendar.current.date(from: dateComponents) {
                        self?.rootView.mainCalendarView.currentPage = date
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


extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarDateCell.description(), for: date, at: position) as? CalendarDateCell else { return FSCalendarCell() }
        
        let day = Calendar.current.component(.day, from: date) - 1
        let data: MonthlyDiary? = day >= 0 && day < calendarData.count ? calendarData[day] : nil
        
        data?.diaryCount
        data?.replyStatus
        
        let isToday = Calendar.current.isDateInToday(date)
        let isSelected = Calendar.current.isDate(date, inSameDayAs: self.viewModel.selectedDateRelay.value)
        let date = DateFormatter.string(from: date, format: "d")
        
        let dayString = String(day + 1)
        
        cell.configure(isToday: isToday, isSelected: isSelected, date: date, data: data ?? MonthlyDiary(diaryCount: 0, replyStatus: ""))
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tapDateRelay.accept(date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return .clear // 날짜 숫자를 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        return .clear // 서브타이틀 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜 숫자를 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜의 서브타이틀 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        return .clear // 기본 테두리 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜의 테두리 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return .clear // 기본 배경색 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .clear // 선택된 날짜의 배경색 숨김
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titlePlaceholderColorFor date: Date) -> UIColor? {
        return .clear // 이전/다음 달 날짜 숨김
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0 // 이벤트 숨김
    }
}
