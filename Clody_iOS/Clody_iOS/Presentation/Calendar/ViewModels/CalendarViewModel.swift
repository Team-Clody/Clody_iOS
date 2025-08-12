//
//  CalendarViewModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/28/24.
//

import UIKit

import RxSwift
import RxCocoa

final class CalendarViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let tapDateCell: Signal<Date>
        let tapCalendarActionButton: Signal<Void>
        let tapListButton: Signal<Void>
        let tapSettingButton: Signal<Void>
        let currentPageChanged: Signal<(year: Int, month: Int)>
        let tapKebabButton: Signal<Void>
        let tapDateButton: Signal<Void>
        let tapDeleteButton: Signal<Void>
    }
    
    struct Output {
        let selectedMonthDay: Driver<String>
        let selectedWeekDay: Driver<String>
        let diaryData: Driver<[DailyDiary]>
        let calendarData: Driver<[MonthlyDiary]>
        let pushListViewController: Signal<Void>
        let pushSettingViewController: Signal<Void>
        let showDeleteBottomSheet: Signal<Void>
        let showPickerView: Signal<Void>
        let changeCalendarDateText: Driver<String>
        let changeCloverCount: Driver<Int>
        let currentPage: Driver<(year: Int, month: Int)>
        let pushWritingDiaryOrReplyWaitingVC: Signal<Void>
        let showDeleteConfirmAlert: Signal<Void>
        let isLoading: Driver<Bool>
        let errorStatus: Driver<String>
        let diaryButtonState: Driver<DiaryButtonState>
    }
    
    let selectedDateRelay = BehaviorRelay<Date>(value: Date())
    let monthlyCalendarDataRelay = BehaviorRelay<CalendarMonthlyResponseDTO>(value: CalendarMonthlyResponseDTO(totalCloverCount: 0, diaries: [MonthlyDiary(diaryCount: 0, replyStatus: "", isDeleted: false)]))
    let dailyDiaryDataRelay = BehaviorRelay<GetDiaryResponseDTO>(value: GetDiaryResponseDTO(diaries: [], isDeleted: false))
    let currentPageRelay = BehaviorRelay<(year: Int, month: Int)>(value: (Date().dateToYearMonthDay().year, Date().dateToYearMonthDay().month))
    let isLoadingRelay = PublishRelay<Bool>()
    let errorStatusRelay = PublishRelay<String>()
    let selectedCloverTypeRelay = BehaviorRelay<CloverType>(value: .none)
    let diaryButtonStateRelay = BehaviorRelay<DiaryButtonState>(value: .writeDisabled)
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: {
                AmplitudeManager.shared.trackEvent("home")
            })
            .disposed(by: disposeBag)
        
        input.tapDateCell
            .emit(onNext: { [weak self] date in
                guard let self = self else { return }
                selectedDateRelay.accept(date)
                
                let year = DateFormatter.string(from: date, format: "yyyy")
                let month = DateFormatter.string(from: date, format: "MM")
                let day = DateFormatter.string(from: date, format: "dd")
                
                getDailyCalendarData(
                    year: Int(year) ?? 0,
                    month: Int(month) ?? 0,
                    date: Int(day) ?? 0
                ) { [weak self] in
                    self?.calculateCloverTypeAndButtonState()
                }
                
                AmplitudeManager.shared.trackEvent("home_calendar_clover")
            })
            .disposed(by: disposeBag)
        
        input.currentPageChanged
            .emit(onNext: { [weak self] date in
                guard let self = self else { return }
                getMonthlyCalendar(year: date.year, month: date.month, completion: {
                    self.currentPageRelay.accept((date.year, date.month))
                })
            })
            .disposed(by: disposeBag)
        
        let selectedMonthDay = selectedDateRelay
            .map { date -> String in
                let selectedDate = DateFormatter.string(from: date, format: "M.d")
                return selectedDate
            }
            .asDriver(onErrorJustReturn: "Error")
        
        let selectedWeekDay = selectedDateRelay
            .map { date -> String in
                let dateSelected = DateFormatter.string(from: date, format: "yyyy-MM-dd")
                return dateSelected
            }
            .asDriver(onErrorJustReturn: "Error")
        
        let diaryData = dailyDiaryDataRelay
            .map { $0.diaries }
            .asDriver(onErrorJustReturn: [])
        
        let calendarData = monthlyCalendarDataRelay
            .map { $0.diaries }
            .asDriver(onErrorJustReturn: [])
        
        let changeCloverCount = monthlyCalendarDataRelay
            .map { $0.totalCloverCount }
            .asDriver(onErrorJustReturn: 0)
        
        let changeCalendarDateText = currentPageRelay
            .map { date -> String in
                return LocalizationConstant.Calendar.localizedYearMonthString(year: date.year, month: date.month)
            }
            .asDriver(onErrorJustReturn: "Error")
        
        let pushListViewController = input.tapListButton.asSignal()
        let pushSettingViewController = input.tapSettingButton.asSignal()
        let showDeleteBottomSheet = input.tapKebabButton.asSignal()
        let showPickerView = input.tapDateButton.asSignal()
        let pushWritingDiaryOrReplyWaitingVC = input.tapCalendarActionButton.asSignal()
        let currentPage = currentPageRelay.asDriver(onErrorJustReturn: (year: Date().dateToYearMonthDay().year, Date().dateToYearMonthDay().month))
        let showDeleteConfirmAlert = input.tapDeleteButton.asSignal()
        let isLoading = isLoadingRelay.asDriver(onErrorJustReturn: false)
        let errorStatus = errorStatusRelay.asDriver(onErrorJustReturn: "")
        let diaryButtonState = diaryButtonStateRelay.asDriver(onErrorJustReturn: .writeDisabled)
        
        return Output(
            selectedMonthDay: selectedMonthDay,
            selectedWeekDay: selectedWeekDay,
            diaryData: diaryData,
            calendarData: calendarData,
            pushListViewController: pushListViewController,
            pushSettingViewController: pushSettingViewController,
            showDeleteBottomSheet: showDeleteBottomSheet,
            showPickerView: showPickerView,
            changeCalendarDateText: changeCalendarDateText,
            changeCloverCount: changeCloverCount,
            currentPage: currentPage,
            pushWritingDiaryOrReplyWaitingVC: pushWritingDiaryOrReplyWaitingVC,
            showDeleteConfirmAlert: showDeleteConfirmAlert,
            isLoading: isLoading,
            errorStatus: errorStatus,
            diaryButtonState: diaryButtonState
        )
    }
}

extension CalendarViewModel {
    
    func fetchData() {
        let dailyYear = DateFormatter.string(from: selectedDateRelay.value, format: "yyyy")
        let dailyMonth = DateFormatter.string(from: selectedDateRelay.value, format: "MM")
        let dailyDay = DateFormatter.string(from: selectedDateRelay.value, format: "dd")
        
        let monthlyYear = currentPageRelay.value.year
        let monthlyMonth = currentPageRelay.value.month
        
        self.getMonthlyCalendar(year: monthlyYear, month: monthlyMonth) {
            self.getDailyCalendarData(year: Int(dailyYear) ?? 0, month: Int(dailyMonth) ?? 0, date: Int(dailyDay) ?? 0, completion: {
                [weak self] in
                self?.calculateCloverTypeAndButtonState()
            })
        }
    }
    
    func getMonthlyCalendar(year: Int, month: Int, completion: @escaping () -> Void) {
        isLoadingRelay.accept(true)
        let provider = Providers.calendarProvider
        
        provider.request(target: .getMonthlyCalendar(year: year, month: month), instance: BaseResponse<CalendarMonthlyResponseDTO>.self) { [weak self] data in
            guard let self = self else { return }
            switch data.status {
            case 200..<300:
                guard let data = data.data else { return }
                self.monthlyCalendarDataRelay.accept(data)
                completion()
            case -1:
                self.errorStatusRelay.accept("networkView")
            default:
                self.errorStatusRelay.accept("unknownedView")
            }
            self.isLoadingRelay.accept(false)
        }
    }
    
    func getDailyCalendarData(year: Int, month: Int, date: Int, completion: @escaping () -> Void) {
        isLoadingRelay.accept(true)
        let provider = Providers.diaryRouter
        
        provider.request(target: .getDailyDiary(year: year, month: month, date: date), instance: BaseResponse<GetDiaryResponseDTO>.self) { [weak self] data in
            guard let self = self else { return }
            switch data.status {
            case 200..<300:
                guard let data = data.data else { return }
                self.dailyDiaryDataRelay.accept(data)
                completion()
            case -1:
                self.errorStatusRelay.accept("networkAlert")
            default:
                self.errorStatusRelay.accept("unknownedAlert")
            }
            self.isLoadingRelay.accept(false)
        }
    }
    
    func deleteDiary(year: Int, month: Int, date: Int) {
        isLoadingRelay.accept(true)
        let provider = Providers.diaryRouter
        
        provider.request(target: .deleteDiary(year: year, month: month, date: date), instance: BaseResponse<EmptyResponseDTO>.self, completion: { data in
            switch data.status {
            case 200..<300:
                self.fetchData()
            case -1:
                self.errorStatusRelay.accept("networkAlert")
            default:
                self.errorStatusRelay.accept("unknownedAlert")
            }
            self.isLoadingRelay.accept(false)
        })
    }
    
    func getCalendarCellViewData(
        for date: Date,
        calendarData: [MonthlyDiary]
    ) -> CalendarCellViewData {
        let day = Calendar.current.component(.day, from: date) - 1
        guard day >= 0, day < calendarData.count else {
            return CalendarCellViewData(cloverType: .none, showNewIcon: false)
        }
        
        let diary = calendarData[day]
        let isToday = date.isToday
        let replyStatus = diary.replyStatus
        let isDeleted = diary.isDeleted
        let diaryCount = diary.diaryCount
        
        let cloverType: CloverType = {
            if isDeleted && diaryCount != 0 {
                return .draftDone
            }
            
            switch replyStatus {
            case "HAS_DRAFT":
                return .hasDraft
            case "INVALID_DRAFT":
                return .draftDone
            case "READY_READ":
                return .fromDiaryCount(diary.diaryCount)
            case "READY_NOT_READ", "UNREADY":
                if isToday {
                    return diary.diaryCount == 0 ? .today : .todayDone
                } else {
                    return .none
                }
            default:
                return .none
            }
        }()
        
        let showNewIcon = (replyStatus == "READY_NOT_READ")
        
        return CalendarCellViewData(cloverType: cloverType, showNewIcon: showNewIcon)
    }
    
    func calculateCloverTypeAndButtonState() {
        let date = selectedDateRelay.value
        let dailyData = dailyDiaryDataRelay.value
        let cloverType = getCalendarCellViewData(for: date, calendarData: monthlyCalendarDataRelay.value.diaries).cloverType
        
        let isNotEmpty = !dailyData.diaries.isEmpty
        let isWritingAvailable = date.isWritingAvailable
        let isDeleted = dailyData.isDeleted
        
        let buttonState: DiaryButtonState
        
        switch cloverType {
        case .hasDraft:
            buttonState = .draftEnabled
        case .draftDone:
            buttonState = .replyDisabled
        default:
            switch (isWritingAvailable, isNotEmpty, isDeleted) {
            case (true, false, _):
                buttonState = .writeEnabled
            case (true, true, false):
                buttonState = .replyEnabled
            case (true, true, true):
                buttonState = .replyDisabled
            case (false, false, _):
                buttonState = .writeDisabled
            case (false, true, false):
                buttonState = .replyEnabled
            case (false, true, true):
                buttonState = .replyDisabled
            }
        }
        
        selectedCloverTypeRelay.accept(cloverType)
        diaryButtonStateRelay.accept(buttonState)
    }
}
