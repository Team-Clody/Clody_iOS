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
    
    let viewModel = CalendarViewModel()
    private let disposeBag = DisposeBag()
    
    private let tapDateRelay = PublishRelay<Date>()
    private let currentPageRelay = PublishRelay<[String]>()
    private var calendarData: [MonthlyDiary] = [MonthlyDiary(diaryCount: 0, replyStatus: "", isDeleted: false)]
    
    private var alert: ClodyAlert?
    private lazy var dimmingView = UIView()
    
    // MARK: - UI Components
    
    private let rootView = CalendarView()
    private let deleteBottomSheetView = DeleteBottomSheetView()
    private let datePickerView = DatePickerView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
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
            tapDeleteButton: deleteBottomSheetView.bottomSheetView.rx.tapGesture()
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
                
                let isNotEmpty = !data.isEmpty
                let isToday = Calendar.current.isDateInToday(self.viewModel.selectedDateRelay.value)
                let isDeleted = self.viewModel.dailyDiaryDataRelay.value.isDeleted
                
                // 기본값 설정
                var buttonTitle = isNotEmpty ? I18N.Calendar.reply : I18N.Calendar.writing
                var buttonColor: UIColor? = isNotEmpty ? UIColor(named: "grey01") : UIColor(named: "mainYellow")
                var textColor: UIColor? = UIColor(named: isNotEmpty ? "white" : "grey02")
                var isEnabled = true
                
                // 버튼 상태 및 색상 결정
                if (isToday && isNotEmpty && isDeleted) || (!isToday && (isDeleted || !isNotEmpty)) {
                    isEnabled = false
                    buttonColor = isNotEmpty ? UIColor(named: "grey07") : UIColor(named: "lightYellow")
                    textColor = UIColor(named: isNotEmpty ? "grey04" : "grey06")
                }
                
                // UI 업데이트
                self.rootView.emptyDiaryView.isHidden = isNotEmpty
                self.rootView.calendarButton.setAttributedTitle(
                    UIFont.pretendardString(text: buttonTitle, style: .body1_semibold),
                    for: .normal
                )
                self.rootView.calendarButton.backgroundColor = buttonColor
                self.rootView.calendarButton.setTitleColor(textColor, for: .normal)
                self.rootView.calendarButton.isEnabled = isEnabled
                
                print(isEnabled, "🍀")
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
                let dayOfContent = DateFormatter.date(from: data)
                rootView.dayLabel.text = dayOfContent?.koreanDayOfWeek()
            })
            .disposed(by: disposeBag)
        
        output.changeToList
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                navigateToList()
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
                let date = viewModel.currentPageRelay.value
                let selectedMonth = "\(date[0])년 \(date[1])월"
                rootView.calendarNavigationView.dateText = selectedMonth
                self.presentPickerView()
            })
            .disposed(by: disposeBag)
        
        output.changeNavigationDate
            .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                rootView.calendarNavigationView.dateText = data
                rootView.mainCalendarView.reloadData()
                rootView.dailyDiaryCollectionView.reloadData()
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
                let date = viewModel.selectedDateRelay.value
                if viewModel.dailyDiaryDataRelay.value.diaries.count != 0 {
                    let dateIndex = Int(DateFormatter.string(from: viewModel.selectedDateRelay.value, format: "dd")) ?? 1
                    let diaries = viewModel.monthlyCalendarDataRelay.value.diaries
                    
                    let replyStatus: String
                    if diaries.indices.contains(dateIndex - 1) {
                        replyStatus = diaries[dateIndex - 1].replyStatus
                    } else {
                        replyStatus = "특정 값"
                    }
                    
                    self.navigationController?.pushViewController(ReplyWaitingViewController(date: date, isHomeBackButton: false), animated: true)
                } else {
                    self.navigationController?.pushViewController(WritingDiaryViewController(date: date), animated: true)
                }
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
                        
                        let year = DateFormatter.string(from: self.viewModel.selectedDateRelay.value, format: "yyyy")
                        let month = DateFormatter.string(from: self.viewModel.selectedDateRelay.value, format: "MM")
                        let day = DateFormatter.string(from: self.viewModel.selectedDateRelay.value, format: "dd")
                        self.viewModel.deleteDiary(year: Int(year) ?? 0, month: Int(month) ?? 0, date: Int(day) ?? 0)
                        self.hideAlert()
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        output.diaryDeleted
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                // 필요한 후처리
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
                case "networkAlert":
                    self?.showRetryView(isNetworkError: true) {
                        self?.viewModel.fetchData()
                    }
                default:
                    self?.showRetryView(isNetworkError: false) {
                        self?.viewModel.fetchData()
                    }
                }
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
                    
                    var dateComponents = DateComponents()
                    dateComponents.year = selectedYear
                    dateComponents.month = selectedMonth
                    dateComponents.day = 1 // 해당 월의 첫 번째 날로 설정
                    
                    if let date = Calendar.current.date(from: dateComponents) {
                        self?.rootView.mainCalendarView.currentPage = date
                    }
                    
                    let selectedMonthYear = ["\(selectedYear)", "\(selectedMonth)"]
                    self?.viewModel.currentPageRelay.accept(selectedMonthYear)
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
    
    private func navigateToList() {
        let listViewController = ListViewController(month: viewModel.currentPageRelay.value)
        
        listViewController.selectedMonthCompletion = { [weak self] data in
            guard let self = self else { return }
            self.viewModel.currentPageRelay.accept(data)
            
            var dateComponents = DateComponents()
            dateComponents.year = Int(data[0])
            dateComponents.month = Int(data[1])
            dateComponents.day = 1 // 해당 월의 첫 번째 날로 설정
            
            if let date = Calendar.current.date(from: dateComponents) {
                self.rootView.mainCalendarView.currentPage = date
            }
        }
        
        self.navigationController?.pushViewController(listViewController, animated: true)
    }

}


extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarDateCell.description(), for: date, at: position) as? CalendarDateCell else { return FSCalendarCell() }
        
        let day = Calendar.current.component(.day, from: date) - 1
        let data: MonthlyDiary? = day >= 0 && day < calendarData.count ? calendarData[day] : nil
        
        let isToday = Calendar.current.isDateInToday(date)
        let isSelected = Calendar.current.isDate(date, inSameDayAs: self.viewModel.selectedDateRelay.value)
        let isDeleted = data?.isDeleted ?? false
        let date = DateFormatter.string(from: date, format: "d")
        
        let dayString = String(day + 1)
        
        cell.configure(isToday: isToday, isSelected: isSelected, isDeleted: isDeleted, date: date, data: data ?? MonthlyDiary(diaryCount: 0, replyStatus: "", isDeleted: false))
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tapDateRelay.accept(date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage.dateToYearMonthDay()
        currentPageRelay.accept([String(currentPage.0), String(currentPage.1)])
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

private extension CalendarViewController {
    
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
        rootView.mainCalendarView.reloadData()
        rootView.dailyDiaryCollectionView.reloadData()
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
