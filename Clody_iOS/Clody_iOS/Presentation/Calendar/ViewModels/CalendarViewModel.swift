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
        let tapResponseButton: Signal<Void>
        let tapListButton: Signal<Void>
        let tapSettingButton: Signal<Void>
        let currentPageChanged: Signal<(year: Int, month: Int)>
        let tapKebabButton: Signal<Void>
        let tapDateButton: Signal<Void>
        let tapDeleteButton: Signal<Void>
    }
    
    struct Output {
        let dateLabel: Driver<String>
        let selectedDate: Driver<String>
        let diaryData: Driver<[DailyDiary]>
        let calendarData: Driver<[MonthlyDiary]>
        let changeToList: Signal<Void>
        let changeToSetting: Signal<Void>
        let showDeleteBottomSheet: Signal<Void>
        let showPickerView: Signal<Void>
        let changeNavigationDate: Driver<String>
        let cloverCount: Driver<Int>
        let currentPage: Driver<(year: Int, month: Int)>
        let diaryDeleted: Signal<Void>
        let navigateToResponse: Signal<Void>
        let showDelete: Signal<Void>
        let isLoading: Driver<Bool>
        let errorStatus: Driver<String>
    }
    
    let selectedDateRelay = BehaviorRelay<Date>(value: Date())
    let monthlyCalendarDataRelay = BehaviorRelay<CalendarMonthlyResponseDTO>(value: CalendarMonthlyResponseDTO(totalCloverCount: 0, diaries: [MonthlyDiary(diaryCount: 0, replyStatus: "", isDeleted: false)]))
    let dailyDiaryDataRelay = BehaviorRelay<GetDiaryResponseDTO>(value: GetDiaryResponseDTO(diaries: [], isDeleted: false))
    let currentPageRelay = BehaviorRelay<(year: Int, month: Int)>(value: (Date().dateToYearMonthDay().year, Date().dateToYearMonthDay().month))
    let isLoadingRelay = PublishRelay<Bool>()
    let errorStatusRelay = PublishRelay<String>()
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: {
                AmplitudeManager.shared.trackEvent("home")
            })
            .disposed(by: disposeBag)
        
        input.tapDateCell
            .emit(onNext: { [weak self] date in
                guard let self = self else { return }
                let year = DateFormatter.string(from: date, format: "yyyy")
                let month = DateFormatter.string(from: date, format: "MM")
                let day = DateFormatter.string(from: date, format: "dd")
                
                self.selectedDateRelay.accept(date)
                self.getDailyCalendarData(year: Int(year) ?? 0, month: Int(month) ?? 0, date: Int(day) ?? 0, completion: {})
                AmplitudeManager.shared.trackEvent("home_calendar_clover")
            })
            .disposed(by: disposeBag)
        
        input.tapDeleteButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                
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
        
        let dateLabel = selectedDateRelay
            .map { date -> String in
                let dateSelected = DateFormatter.string(from: date, format: "M.d")
                return dateSelected
            }
            .asDriver(onErrorJustReturn: "Error")
        
        let selectedDate = selectedDateRelay
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
        
        let cloverCount = monthlyCalendarDataRelay
            .map { $0.totalCloverCount }
            .asDriver(onErrorJustReturn: 0)
        
        let changeNavigationDate = currentPageRelay
            .map { date -> String in
                return "\(date.year)년 \(date.month)월"
            }
            .asDriver(onErrorJustReturn: "Error")
        
        let changeToList = input.tapListButton.asSignal()
        let changeToSetting = input.tapSettingButton.asSignal()
        let showDeleteBottomSheet = input.tapKebabButton.asSignal()
        let showPickerView = input.tapDateButton.asSignal()
        let navigateToResponse = input.tapResponseButton.asSignal()
        let currentPage = currentPageRelay.asDriver(onErrorJustReturn: (year: Date().dateToYearMonthDay().year, Date().dateToYearMonthDay().month))
        let diaryDeleted = input.tapDeleteButton.asSignal()
        let showDelete = input.tapDeleteButton.asSignal()
        let isLoading = isLoadingRelay.asDriver(onErrorJustReturn: false)
        let errorStatus = errorStatusRelay.asDriver(onErrorJustReturn: "")
        
        return Output(
            dateLabel: dateLabel,
            selectedDate: selectedDate,
            diaryData: diaryData,
            calendarData: calendarData,
            changeToList: changeToList,
            changeToSetting: changeToSetting,
            showDeleteBottomSheet: showDeleteBottomSheet,
            showPickerView: showPickerView,
            changeNavigationDate: changeNavigationDate,
            cloverCount: cloverCount,
            currentPage: currentPage,
            diaryDeleted: diaryDeleted,
            navigateToResponse: navigateToResponse,
            showDelete: showDelete,
            isLoading: isLoading,
            errorStatus: errorStatus
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
            self.getDailyCalendarData(year: Int(dailyYear) ?? 0, month: Int(dailyMonth) ?? 0, date: Int(dailyDay) ?? 0, completion: {})
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
            case -1:
                self.errorStatusRelay.accept("networkAlert")
            default:
                self.errorStatusRelay.accept("unknownedAlert")
            }
            self.isLoadingRelay.accept(false)
            completion()  
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
}
