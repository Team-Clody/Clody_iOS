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
    private let currentPageChanged = PublishRelay<(year: Int, month: Int)>()
    private var calendarData: [MonthlyDiary] {
        viewModel.monthlyCalendarDataRelay.value.diaries
    }
    
    // MARK: - UI Components
    
    private let rootView = CalendarView()
    private lazy var deleteBottomSheetView = DeleteBottomSheetView()
    private lazy var datePickerView = DatePickerView()
    private lazy var continueWritingAlarmBottomSheet = ContinueWritingAlarmBottomSheet()
    private var alert: ClodyAlert?
    private lazy var dimmingView = UIView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppStoreReviewManager.requestReviewIfNeeded()
        viewModel.fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        registerCells()
        bindViewModel()
        setUI()
    }
}

// MARK: - Extensions

private extension CalendarViewController {
    
    func bindViewModel() {
        let input = CalendarViewModel.Input(
            viewDidLoad: Observable.just(()),
            tapDateCell: tapDateRelay.asSignal(),
            tapCalendarActionButton: rootView.calendarActionButton.rx.tap.asSignal(),
            tapListButton: rootView.calendarNavigationView.listButton.rx.tap.asSignal(),
            tapSettingButton: rootView.calendarNavigationView.settingButton.rx.tap.asSignal(),
            currentPageChanged: currentPageChanged.asSignal(),
            tapKebabButton:  rootView.kebabButton.rx.tap.asSignal(),
            tapDateButton: rootView.calendarNavigationView.dateButton.rx.tap.asSignal(),
            tapDeleteButton: deleteBottomSheetView.bottomSheetView.rx.tapGesture()
                .when(.recognized)
                .map { _ in }
                .asSignal(onErrorJustReturn: ())
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.selectedMonthDay
            .drive(rootView.dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.selectedWeekDay
            .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                rootView.mainCalendarView.reloadData()
                let dayOfContent = DateFormatter.date(from: data)
                rootView.dayLabel.text = dayOfContent?.koreanDayOfWeek()
            })
            .disposed(by: disposeBag)
        
        //데일리 다이어리 업데이트
        
        output.diaryButtonState
            .drive(onNext: { [weak self] state in
                guard let self = self else { return }
                
                let config: (text: String, backgroundColor: UIColor?, titleColor: UIColor?, isEnabled: Bool) = {
                    switch state {
                    case .writeEnabled:
                        return (
                            text: I18N.Calendar.writing,
                            backgroundColor: .mainYellow,
                            titleColor: .grey02,
                            isEnabled: true
                        )
                    case .writeDisabled:
                        return (
                            text: I18N.Calendar.writing,
                            backgroundColor: .lightYellow,
                            titleColor: .grey06,
                            isEnabled: false
                        )
                    case .replyEnabled:
                        return (
                            text: I18N.Calendar.reply,
                            backgroundColor: .grey01,
                            titleColor: .white,
                            isEnabled: true
                        )
                    case .replyDisabled:
                        return (
                            text: I18N.Calendar.reply,
                            backgroundColor: .grey07,
                            titleColor: .grey04,
                            isEnabled: false
                        )
                        
                    case .draftEnabled:
                        return (
                            text: I18N.Calendar.writeMore,
                            backgroundColor: .mainYellow,
                            titleColor: .grey02,
                            isEnabled: true
                        )
                    }
                }()
                let emptyText: String = {
                    switch state {
                    case .draftEnabled:
                        return I18N.Calendar.draft
                    default:
                        return I18N.Calendar.empty
                    }
                }()
                self.rootView.emptyDiaryLabel.attributedText = UIFont.pretendardString(text: emptyText, style: .body3_regular)
                self.rootView.emptyDiaryView.isHidden = (state == .replyEnabled || state == .replyDisabled)
                self.rootView.kebabButton.isHidden = (state == .writeDisabled || state == .writeEnabled)
                self.rootView.calendarActionButton.setAttributedTitle(
                    UIFont.pretendardString(text: config.text, style: .body1_semibold),
                    for: .normal
                )
                self.rootView.calendarActionButton.backgroundColor = config.backgroundColor
                self.rootView.calendarActionButton.setTitleColor(config.titleColor, for: .normal)
                self.rootView.calendarActionButton.isEnabled = config.isEnabled
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
                rootView.mainCalendarView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.pushListViewController
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                navigateToListViewController()
            })
            .disposed(by: disposeBag)
        
        output.pushSettingViewController
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                navigationController?.pushViewController(SettingViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showDeleteBottomSheet
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                presentBottomSheet(deleteBottomSheetView)
            })
            .disposed(by: disposeBag)
        
        output.showPickerView
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                let date = viewModel.currentPageRelay.value
                let selectedMonth = "\(date.year)년 \(date.month)월"
                rootView.calendarNavigationView.dateText = selectedMonth
                presentBottomSheet(datePickerView)
            })
            .disposed(by: disposeBag)
        
        output.changeCalendarDateText
            .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                rootView.calendarNavigationView.dateText = data
            })
            .disposed(by: disposeBag)
        
        output.changeCloverCount
            .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                rootView.cloverLabel.text = "클로버 \(data)개"
            })
            .disposed(by: disposeBag)
        
        output.pushWritingDiaryOrReplyWaitingVC
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                let date = viewModel.selectedDateRelay.value
                let status = viewModel.diaryButtonStateRelay.value
                
                switch status {
                case .writeEnabled:
                    AmplitudeManager.shared.trackEvent("home_writing_diary")
                    navigationController?.pushViewController(WritingDiaryViewController(date: date, isFromDraft: false), animated: true)
                case .replyEnabled:
                    AmplitudeManager.shared.trackEvent("home_reply")
                    navigationController?.pushViewController(ReplyWaitingViewController(date: date, isHomeBackButton: false), animated: true)
                case .draftEnabled:
                    if date.isWritingAvailable {
                        navigationController?.pushViewController(WritingDiaryViewController(date: date, isFromDraft: true), animated: true)
                        AmplitudeManager.shared.trackEvent("home_writing_diary")
                    } else {
                        showNoReplyDraftAlert(currentDate: date)
                    }
                default:
                    print("navigate error")
                }
            })
            .disposed(by: disposeBag)
        
        output.showDeleteConfirmAlert
            .emit(onNext: { [weak self] index in
                guard let self = self else { return }
                showAlert(
                    type: .deleteDiary,
                    title: I18N.Alert.deleteDiaryTitle,
                    message: I18N.Alert.deleteDiaryMessage,
                    rightButtonText: I18N.Alert.delete
                )
                
                alert?.leftButton.rx.tap
                    .subscribe(onNext: {
                        self.hideAlert()
                        AmplitudeManager.shared.trackEvent("home_no_delete_diary")
                    })
                    .disposed(by: self.disposeBag)
                
                alert?.rightButton.rx.tap
                    .subscribe(onNext: {
                        let year = DateFormatter.string(from: self.viewModel.selectedDateRelay.value, format: "yyyy")
                        let month = DateFormatter.string(from: self.viewModel.selectedDateRelay.value, format: "MM")
                        let day = DateFormatter.string(from: self.viewModel.selectedDateRelay.value, format: "dd")
                        self.viewModel.deleteDiary(year: Int(year) ?? 0, month: Int(month) ?? 0, date: Int(day) ?? 0)
                        self.hideAlert()
                        AmplitudeManager.shared.trackEvent("home_delete_diary")
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
    
    func registerCells() {
        rootView.mainCalendarView.register(CalendarDateCell.self, forCellReuseIdentifier: CalendarDateCell.description())
        rootView.dailyDiaryCollectionView.register(DailyCalendarCollectionViewCell.self, forCellWithReuseIdentifier: DailyCalendarCollectionViewCell.description())
    }
    
    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        setupDeleteBottomSheet()
        setupDraftAlarmBottomSheet()
        setupPickerView()
    }
    
    func showNoReplyDraftAlert(currentDate: Date) {
        showAlert(
            type: .draftWriteMore,
            title: I18N.Alert.writeMoreTitle,
            message: I18N.Alert.writeMoreMessage,
            rightButtonText: I18N.Alert.writeMore
        )

        guard let alert = self.alert else { return }

        alert.leftButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hideAlert()
            })
            .disposed(by: disposeBag)

        alert.rightButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.hideAlert()
                self.navigationController?.pushViewController(WritingDiaryViewController(date: currentDate, isFromDraft: true), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func setupDeleteBottomSheet() {
        self.view.addSubview(deleteBottomSheetView)
        deleteBottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        deleteBottomSheetView.isHidden = true
        
        deleteBottomSheetView.bottomSheetView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                dismissBottomSheet(deleteBottomSheetView, animated: true)
            })
            .disposed(by: disposeBag)
        
        deleteBottomSheetView.dimmedView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                dismissBottomSheet(deleteBottomSheetView, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func setupDraftAlarmBottomSheet() {
        self.view.addSubview(continueWritingAlarmBottomSheet)
        continueWritingAlarmBottomSheet.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        continueWritingAlarmBottomSheet.isHidden = true
        
        continueWritingAlarmBottomSheet.enableNotificationButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                dismissBottomSheet(continueWritingAlarmBottomSheet, animated: true)
                
                // TODO: 알림 설정 API 호출
            })
            .disposed(by: self.disposeBag)
        
        continueWritingAlarmBottomSheet.skipForNowButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                dismissBottomSheet(continueWritingAlarmBottomSheet, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    func setupPickerView() {
        self.view.addSubview(datePickerView)
        datePickerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        datePickerView.isHidden = true
        
        datePickerView.navigationBar.xButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                dismissBottomSheet(datePickerView, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        datePickerView.completeButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                dismissBottomSheet(datePickerView, animated: true) {
                    let selectedYearIndex = self.datePickerView.pickerView.selectedRow(inComponent: 0)
                    let selectedMonthIndex = self.datePickerView.pickerView.selectedRow(inComponent: 1)
                    let selectedYear = self.datePickerView.pickerView.years[selectedYearIndex]
                    let selectedMonth = self.datePickerView.pickerView.months[selectedMonthIndex]
                    
                    var dateComponents = DateComponents()
                    dateComponents.year = selectedYear
                    dateComponents.month = selectedMonth
                    dateComponents.day = 1 // 해당 월의 첫 번째 날로 설정
                    
                    if let date = Calendar.current.date(from: dateComponents) {
                        self.rootView.mainCalendarView.currentPage = date
                    }
                    self.currentPageChanged.accept((selectedYear, selectedMonth))
                }
            })
            .disposed(by: disposeBag)
        
        datePickerView.dimmedView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                dismissBottomSheet(datePickerView, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func navigateToListViewController() {
        // TODO: ListViewController에서도 통일성 있게 배열 대신 튜플로 받아주도록 변경하기
        let currentYearMonthArray = ["\(viewModel.currentPageRelay.value.year)", "\(viewModel.currentPageRelay.value.month)"]
        let listViewController = ListViewController(month: currentYearMonthArray)
        
        listViewController.selectedMonthCompletion = { [weak self] data in
            guard let self = self else { return }
            var dateComponents = DateComponents()
            dateComponents.year = Int(data[0])
            dateComponents.month = Int(data[1])
            dateComponents.day = 1 // 해당 월의 첫 번째 날로 설정
            
            if let date = Calendar.current.date(from: dateComponents) {
                self.rootView.mainCalendarView.currentPage = date
            }
            self.viewModel.currentPageRelay.accept((dateComponents.year ?? 0, dateComponents.month ?? 0))
        }
        
        AmplitudeManager.shared.trackEvent("home_list_diary")
        self.navigationController?.pushViewController(listViewController, animated: true)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(
            withIdentifier: CalendarDateCell.description(), for: date, at: position
        ) as? CalendarDateCell else {
            return FSCalendarCell()
        }
        
        let isSelected = Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDateRelay.value)
        let isToday = date.isToday
        let dateText = DateFormatter.string(from: date, format: "d")
        
        let viewData = viewModel.getCalendarCellViewData(for: date, calendarData: calendarData)
        
        cell.configure(
            isSelected: isSelected,
            dateText: dateText,
            cloverType: viewData.cloverType,
            showNewIcon: viewData.showNewIcon,
            isToday: isToday
        )
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tapDateRelay.accept(date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage.dateToYearMonthDay()
        viewModel.currentPageRelay.accept((currentPage.year, currentPage.month))
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
    
    func presentBottomSheet(_ bottomSheet: BottomSheet) {
        bottomSheet.isHidden = false
        bottomSheet.animateShow()
    }
    
    func dismissBottomSheet(_ bottomSheet: BottomSheet, animated: Bool, completion: (() -> Void)? = nil) {
        bottomSheet.animateHide {
            bottomSheet.isHidden = true
            completion?()
        }
    }
    
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
