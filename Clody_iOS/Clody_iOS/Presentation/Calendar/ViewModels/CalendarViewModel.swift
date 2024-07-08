//
//  CalendarViewModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/28/24.
//

import UIKit

import RxSwift
import RxCocoa

protocol CalendarViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output
}

final class CalendarViewModel: CalendarViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let tapDateCell: Signal<Date>
        let tapResponseButton: Signal<Void>
        let currentPageChanged: Signal<Date>
    }
    
    struct Output {
        let cellText: Driver<String>
        let cellStatus: Driver<String>
        let dateLabel: Driver<String>
        let diaryText: Driver<String>
        let selectedDate: Driver<String>
        let responseButtonStatus: Driver<String>
    }
    
    let selectedDateRelay = BehaviorRelay<Date>(value: Date())
    let statusRelay = BehaviorRelay<Int>(value: 0)
    let calendarDummyDataRelay = BehaviorRelay<CalendarModel>(value: CalendarModel(month: "", cellData: [CalendarCellModel(date: "", cloverStatus: "")]))
    let dailyDiaryDummyDataRelay = BehaviorRelay<CalendarDailyModel>(value: CalendarDailyModel(date: "", status: "", diary: []))
    let responseButtonStatusRelay = BehaviorRelay<String>(value: "")
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let today = Date()
                self.selectedDateRelay.accept(today)
                self.loadDummyData(for: today)
            })
            .disposed(by: disposeBag)
        
        input.tapDateCell
            .emit(onNext: { [weak self] date in
                guard let self = self else { return }
                self.selectedDateRelay.accept(date)
                self.loadDailyDummyData(for: date)
            })
            .disposed(by: disposeBag)
        
        input.tapResponseButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.responseButtonStatusRelay.accept(self.dailyDiaryDummyDataRelay.value.status)
            })
            .disposed(by: disposeBag)
        
        let cellText = calendarDummyDataRelay
            .map { $0.cellData.first?.date ?? "No Data" }
            .asDriver(onErrorJustReturn: "Error")
        
        let cellStatus = calendarDummyDataRelay
            .map { $0.cellData.first?.cloverStatus ?? "No Status" }
            .asDriver(onErrorJustReturn: "Error")
        
        let dateLabel = selectedDateRelay
            .map { date -> String in
                let dateSelected = DateFormatter.string(from: date, format: "M.dd")
                return dateSelected
            }
            .asDriver(onErrorJustReturn: "Error")
        
        let diaryText = dailyDiaryDummyDataRelay
            .map { $0.diary.isEmpty ? "No Diary" : $0.diary.joined(separator: "\n") }
            .asDriver(onErrorJustReturn: "Error")
        
        let selectedDate = selectedDateRelay
            .map { date -> String in
                let dateSelected = DateFormatter.string(from: date, format: "yyyy-MM-dd")
                return dateSelected
            }
            .asDriver(onErrorJustReturn: "Error")
        
        let responseButtonStatus = responseButtonStatusRelay.asDriver(onErrorJustReturn: "")
        
        return Output(
            cellText: cellText,
            cellStatus: cellStatus,
            dateLabel: dateLabel,
            diaryText: diaryText,
            selectedDate: selectedDate,
            responseButtonStatus: responseButtonStatus
        )
        
    }
}

extension CalendarViewModel {
    
    private func loadDummyData(for date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let monthString = dateFormatter.string(from: date)
        let calendarData = CalendarModel.dummy(monthString: monthString)
        self.calendarDummyDataRelay.accept(calendarData)
        
        let dateString = DateFormatter.string(from: date, format: "yyyy-MM-dd")
        let dailyData = CalendarDailyModel.dummy(dateString: dateString)
        self.dailyDiaryDummyDataRelay.accept(dailyData)
    }
    
    private func loadDailyDummyData(for date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        let dailyData = CalendarDailyModel.dummy(dateString: dateString)
        self.dailyDiaryDummyDataRelay.accept(dailyData)
    }
}
