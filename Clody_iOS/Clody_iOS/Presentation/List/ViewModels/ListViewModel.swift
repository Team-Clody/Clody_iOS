//
//  ListViewModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ListViewModel: CalendarViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let tapDateCell: Signal<Date>
        let tapResponseButton: Signal<Void>
        let currentPageChanged: Signal<Date>
    }
    
    struct Output {
        let dateLabel: Driver<String>
        let selectedDate: Driver<String>
        let responseButtonStatus: Driver<String>
        let diaryData: Driver<[String]>
        let calendarData: Driver<[CalendarCellModel]>
    }
    
    let selectedDateRelay = BehaviorRelay<Date>(value: Date())
    let calendarDummyDataRelay = BehaviorRelay<CalendarModel>(value: CalendarModel(month: "", cellData: [CalendarCellModel(date: "", cloverStatus: "")]))
    let dailyDiaryDummyDataRelay = BehaviorRelay<CalendarDailyModel>(value: CalendarDailyModel(date: "", status: "", diary: []))
    let responseButtonStatusRelay = BehaviorRelay<String>(value: "")
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
//        input.viewDidLoad
//            .subscribe(onNext: { [weak self] in
//                guard let self = self else { return }
//                let today = Date()
//                self.selectedDateRelay.accept(today)
//                self.loadDummyData(for: today)
//            })
//            .disposed(by: disposeBag)
//        
//        input.tapDateCell
//            .emit(onNext: { [weak self] date in
//                guard let self = self else { return }
//                self.selectedDateRelay.accept(date)
//                self.loadDailyDummyData(for: date)
//            })
//            .disposed(by: disposeBag)
        
        input.tapResponseButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.responseButtonStatusRelay.accept(self.dailyDiaryDummyDataRelay.value.status)
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
        
        let diaryData = dailyDiaryDummyDataRelay
            .map { $0.diary }
            .asDriver(onErrorJustReturn: [])
        
        let calendarData = calendarDummyDataRelay
            .map { $0.cellData }
            .asDriver(onErrorJustReturn: [])
        
        return Output(
            dateLabel: dateLabel,
            selectedDate: selectedDate,
            responseButtonStatus: responseButtonStatus,
            diaryData: diaryData,
            calendarData: calendarData
        )
    }
}

extension CalendarViewModel {
    
    private func loadDummyData(for date: Date) {
        let monthString = DateFormatter.string(from: date, format: "yyyy-MM")
        let calendarData = CalendarModel.dummy(monthString: monthString)
        self.calendarDummyDataRelay.accept(calendarData)
        
        let dateString = DateFormatter.string(from: date, format: "yyyy-MM-dd")
        let dailyData = CalendarDailyModel.dummy(dateString: dateString)
        self.dailyDiaryDummyDataRelay.accept(dailyData)
    }
    
    private func loadDailyDummyData(for date: Date) {
        let dateString = DateFormatter.string(from: date, format: "yyyy-MM-dd")
        let dailyData = CalendarDailyModel.dummy(dateString: dateString)
        self.dailyDiaryDummyDataRelay.accept(dailyData)
    }
}

