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
        let currentPageChanged: Signal<[String]>
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
        let currentPage: Driver<[String]>
        let diaryDeleted: Signal<Void>
        let navigateToResponse: Signal<Void>
        let showDelete: Signal<Void>
        let isLoading: Driver<Bool>
        let errorStatus: Driver<String>
    }
    
    let selectedDateRelay = BehaviorRelay<Date>(value: Date())
    let monthlyCalendarDataRelay = BehaviorRelay<CalendarMonthlyResponseDTO>(value: CalendarMonthlyResponseDTO(totalCloverCount: 0, diaries: [MonthlyDiary(diaryCount: 0, replyStatus: "", isDeleted: false)]))
    let dailyDiaryDataRelay = BehaviorRelay<GetDiaryResponseDTO>(value: GetDiaryResponseDTO(diaries: [], isDeleted: false))
    let currentPageRelay = BehaviorRelay<[String]>(value: ["\(Date().dateToYearMonthDay().0)", "\(Date().dateToYearMonthDay().1)"])
    let isLoadingRelay = PublishRelay<Bool>()
    let errorStatusRelay = PublishRelay<String>()
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
            })
            .disposed(by: disposeBag)
        
        input.tapDateCell
            .emit(onNext: { [weak self] date in
                guard let self = self else { return }
                let year = DateFormatter.string(from: date, format: "yyyy")
                let month = DateFormatter.string(from: date, format: "MM")
                let day = DateFormatter.string(from: date, format: "dd")
                
                self.selectedDateRelay.accept(date)
                self.getDailyCalendarData(year: Int(year) ?? 0, month: Int(month) ?? 0, date: Int(day) ?? 0)
            })
            .disposed(by: disposeBag)
        
        input.currentPageChanged
            .emit(onNext: { [weak self] date in
                guard let self = self else { return }
                self.currentPageRelay.accept(date)
                let year = date[0]
                let month = date[1]
                
                self.getMonthlyCalendar(year: Int(year) ?? 0, month: Int(month) ?? 0)
            })
            .disposed(by: disposeBag)
        
        input.tapDeleteButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                
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
        
        let changeToList = input.tapListButton.asSignal()
        
        let changeToSetting = input.tapSettingButton.asSignal()
        
        let showDeleteBottomSheet = input.tapKebabButton.asSignal()
        
        let showPickerView = input.tapDateButton.asSignal()
        
        let changeNavigationDate = currentPageRelay
            .map { date -> String in
                let year = date[0]
                guard let month = DateFormatter.convertToDoubleDigitMonth(from: date[1]) else { return ""}
                let dateSelected = "\(year)년 \(month)월"
                
                return dateSelected
            }
            .asDriver(onErrorJustReturn: "Error")
        
        let navigateToResponse = input.tapResponseButton.asSignal()
        
        let currentPage = currentPageRelay.asDriver(onErrorJustReturn: ["\(Date().dateToYearMonthDay().0)", "\(Date().dateToYearMonthDay().1)"])
        
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
    
    func getMonthlyCalendar(year: Int, month: Int) {
        isLoadingRelay.accept(true)
        let provider = Providers.calendarProvider
        
        provider.request(target: .getMonthlyCalendar(year: year, month: month), instance: BaseResponse<CalendarMonthlyResponseDTO>.self, completion: { data in
            switch data.status {
            case 200..<300: 
                guard let data = data.data else { return }
                
                self.monthlyCalendarDataRelay.accept(data)
            case -1:
                self.errorStatusRelay.accept("networkView")
            default: 
                self.errorStatusRelay.accept("unknownedView")
            }
    
            self.currentPageRelay.accept([String(year), String(month)])
            self.isLoadingRelay.accept(false)
        })
    }
    
    func getDailyCalendarData(year: Int, month: Int, date: Int) {
        isLoadingRelay.accept(true)
        let provider = Providers.diaryRouter
        
        provider.request(target: .getDailyDiary(year: year, month: month, date: date), instance: BaseResponse<GetDiaryResponseDTO>.self, completion: { data in
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
        })
    }
    
    func deleteDiary(year: Int, month: Int, date: Int) {
        isLoadingRelay.accept(true)
        let provider = Providers.diaryRouter
        
        provider.request(target: .deleteDiary(year: year, month: month, date: date), instance: BaseResponse<EmptyResponseDTO>.self, completion: { data in
            switch data.status {
            case 200..<300:
                guard let data = data.data else { return }
                
                self.getMonthlyCalendar(year: year, month: month)
                self.getDailyCalendarData(year: year, month: month, date: date)
            case -1:
                self.errorStatusRelay.accept("networkAlert")
            default:
                self.errorStatusRelay.accept("unknownedAlert")
            }
            self.isLoadingRelay.accept(false)
        })
    }
    
    func fetchData() {
        let dailyYear = DateFormatter.string(from: selectedDateRelay.value, format: "yyyy")
        let dailyMonth = DateFormatter.string(from: selectedDateRelay.value, format: "MM")
        let dailyDay = DateFormatter.string(from: selectedDateRelay.value, format: "dd")
        
        let monthlyYear = currentPageRelay.value[0]
        let monthlyMonth = currentPageRelay.value[1]
        
        self.getDailyCalendarData(year: Int(dailyYear) ?? 0, month: Int(dailyMonth) ?? 0, date: Int(dailyDay) ?? 0)
        self.getMonthlyCalendar(year: Int(monthlyYear) ?? 0, month: Int(monthlyMonth) ?? 0)
    }
}
