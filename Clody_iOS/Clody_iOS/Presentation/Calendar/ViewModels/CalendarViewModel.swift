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
        let currentPageChanged: Signal<Date>
        let tapKebabButton: Signal<Void>
        let tapDateButton: Signal<Void>
    }
    
    struct Output {
        let dateLabel: Driver<String>
        let selectedDate: Driver<String>
        let responseButtonStatus: Driver<String>
        let diaryData: Driver<[DailyDiary]>
        let calendarData: Driver<[MonthlyDiary]>
        let selectedDateRelay: BehaviorRelay<Date>
        let calendarDummyDataRelay: BehaviorRelay<CalendarMonthlyResponseDTO>
        let dailyDiaryDummyDataRelay: BehaviorRelay<GetDiaryResponseDTO>
        let responseButtonStatusRelay: BehaviorRelay<String>
        let changeToList: Signal<Void>
        let changeToSetting: Signal<Void>
        let showDeleteBottomSheet: Signal<Void>
        let showPickerView: Signal<Void>
        let changeNavigationDate: Driver<String>
        let cloverCount: Driver<Int>
    }
    
    let selectedDateRelay = BehaviorRelay<Date>(value: Date())
    let monthlyCalendarDataRelay = BehaviorRelay<CalendarMonthlyResponseDTO>(value: CalendarMonthlyResponseDTO(totalMonthlyCount: 0, diaries: [MonthlyDiary(diaryCount: 0, replyStatus: "")]))
    let dailyDiaryDataRelay = BehaviorRelay<GetDiaryResponseDTO>(value: GetDiaryResponseDTO(diaries: []))
    let responseButtonStatusRelay = BehaviorRelay<String>(value: "")
    let selectedMonthRelay = BehaviorRelay<[String]>(value: ["2024", "7"])
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let today = Date()
                self.selectedDateRelay.accept(today)
                self.getMonthlyCalendar(year: 2024, month: 7)
            })
            .disposed(by: disposeBag)
        
        input.tapDateCell
            .emit(onNext: { [weak self] date in
                guard let self = self else { return }
                self.selectedDateRelay.accept(date)
//                self.loadDailyDummyData(for: date)
            })
            .disposed(by: disposeBag)
        
        input.tapResponseButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
//                self.responseButtonStatusRelay.accept(self)
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
        
        let responseButtonStatus = responseButtonStatusRelay.asDriver(onErrorJustReturn: "")
        
        let diaryData = dailyDiaryDataRelay
            .map { $0.diaries }
            .asDriver(onErrorJustReturn: [])
        
        let calendarData = monthlyCalendarDataRelay
            .map { $0.diaries }
            .asDriver(onErrorJustReturn: [])
        
        let cloverCount = monthlyCalendarDataRelay
            .map { $0.totalMonthlyCount }
            .asDriver(onErrorJustReturn: 0)
        
        let changeToList = input.tapListButton.asSignal()
        
        let changeToSetting = input.tapSettingButton.asSignal()
        
        let showDeleteBottomSheet = input.tapKebabButton.asSignal()
        
        let showPickerView = input.tapDateButton.asSignal()
        
        let changeNavigationDate = selectedMonthRelay
            .map { date -> String in
                let dateSelected = "\(date[0])년 \(date[1])월"
                return dateSelected
            }
            .asDriver(onErrorJustReturn: "Error")

        
        return Output(
            dateLabel: dateLabel,
            selectedDate: selectedDate,
            responseButtonStatus: responseButtonStatus,
            diaryData: diaryData,
            calendarData: calendarData,
            selectedDateRelay: selectedDateRelay,
            calendarDummyDataRelay: monthlyCalendarDataRelay,
            dailyDiaryDummyDataRelay: dailyDiaryDataRelay,
            responseButtonStatusRelay: responseButtonStatusRelay,
            changeToList: changeToList, 
            changeToSetting: changeToSetting, 
            showDeleteBottomSheet: showDeleteBottomSheet, 
            showPickerView: showPickerView, 
            changeNavigationDate: changeNavigationDate,
            cloverCount: cloverCount
        )
    }
}

extension CalendarViewModel {
    
//    private func loadDummyData(for date: Date) {
//        let monthString = DateFormatter.string(from: date, format: "yyyy-MM")
//        let calendarData = CalendarModel.dummy(monthString: monthString)
//        self.calendarDummyDataRelay.accept(calendarData)
//        
//        let dateString = DateFormatter.string(from: date, format: "yyyy-MM-dd")
//        let dailyData = CalendarDailyModel.dummy(dateString: dateString)
//        self.dailyDiaryDummyDataRelay.accept(dailyData)
//    }
//    
//    private func loadDailyDummyData(for date: Date) {
//        let dateString = DateFormatter.string(from: date, format: "yyyy-MM-dd")
//        let dailyData = CalendarDailyModel.dummy(dateString: dateString)
//        // 데이터를 받아온 시점 칸의 개수 * 최대 높이 + 캘린더 높이 막 이런 식으로 remake를 해주기
//        // 뷰컨으로 값 넘겨서 remake
//        self.dailyDiaryDummyDataRelay.accept(dailyData)
//    }
    
    func getMonthlyCalendar(year: Int, month: Int) {
        let provider = Providers.calendarProvider

        provider.request(target: .getMonthlyCalendar(year: year, month: month), instance: BaseResponse<CalendarMonthlyResponseDTO>.self, completion: { data in
            guard let data = data.data else { return }
            
            self.monthlyCalendarDataRelay.accept(data)
        })
    }
    
    func getDailyCalendarData(year: Int, month: Int, date: Int) {
        let provider = Providers.diaryRouter

        provider.request(target: .getDailyDiary(year: year, month: month, date: date), instance: BaseResponse<GetDiaryResponseDTO>.self, completion: { data in
            guard let data = data.data else { return }
            
            self.dailyDiaryDataRelay.accept(data)
        })
    }
}
