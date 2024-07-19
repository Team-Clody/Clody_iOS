//
//  ListViewModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ListViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let tapReplyButton: Signal<String>
        let tapKebabButton: Signal<String>
        let tapCalendarButton: Signal<Void>
        let tapDateButton: Signal<Void>
        let monthTap: Signal<String>
        let tapDeleteButton: Signal<Void>
    }
    
    struct Output {
        let replyDate: Driver<String>
        let kebabDate: Driver<String>
        let changeToCalendar: Signal<Void>
        let showPickerView: Signal<Void>
        let changeNavigationDate: Driver<String>
        let listDataChanged: Driver<[ListDiary]>
        let showDelete: Signal<Void>
    }
    
    let listDataRelay = BehaviorRelay<CalendarListResponseDTO>(value: CalendarListResponseDTO(totalCloverCount: 0, diaries: []))
    let selectedMonthRelay = BehaviorRelay<[String]>(value: ["", ""])
    let selectedDateRelay = BehaviorRelay<String?>(value: nil)
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        input.viewDidLoad
            .observe(on: MainScheduler.asyncInstance)  
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let today = Date()
                let year = DateFormatter.string(from: today, format: "yyyy")
                let month = DateFormatter.string(from: today, format: "MM")
                self.getListData(year: Int(year) ?? 0, month: Int(month) ?? 0)
                self.selectedMonthRelay.accept([year, month])
            })
            .disposed(by: disposeBag)
        
        input.tapKebabButton
             .emit(onNext: { [weak self] date in
                 self?.selectedDateRelay.accept(date)
             })
             .disposed(by: disposeBag)
        
        let replyDate = input.tapReplyButton
            .asDriver(onErrorJustReturn: "")
        
        let kebabDate = input.tapKebabButton
            .asDriver(onErrorJustReturn: "")
        
        let listDataChanged = listDataRelay
            .map { $0.diaries }
            .asDriver(onErrorJustReturn: [])
        
        let changeToCalendar = input.tapCalendarButton.asSignal()
        
        let showDeleteBottomSheet = input.tapKebabButton.asSignal()
        
        let showPickerView = input.tapDateButton.asSignal()
        
        let changeNavigationDate = selectedMonthRelay
            .observe(on: MainScheduler.asyncInstance)  
            .map { date -> String in
                let year = self.selectedMonthRelay.value[0]
                let month = self.selectedMonthRelay.value[1]

                self.getListData(year: Int(year) ?? 0, month: Int(month) ?? 0)
                let dateSelected = "\(date[0])년 \(date[1])월"
                return dateSelected
            }
            .asDriver(onErrorJustReturn: "Error")
        
        let showDelete = input.tapDeleteButton.asSignal()
        
        return Output(
            replyDate: replyDate,
            kebabDate: kebabDate,
            changeToCalendar: changeToCalendar,
            showPickerView: showPickerView,
            changeNavigationDate: changeNavigationDate, 
            listDataChanged: listDataChanged,
            showDelete: showDelete
        )
    }
}

extension ListViewModel {
    
    func getListData(year: Int, month: Int) {
        let provider = Providers.calendarProvider

        provider.request(target: .getListCalendar(year: year, month: month), instance: BaseResponse<CalendarListResponseDTO>.self, completion: { data in
            guard let data = data.data else { return }
            
            self.listDataRelay.accept(data)
        })
    }
    
    func deleteDiary(year: Int, month: Int, date: Int) {
        let provider = Providers.diaryRouter

        provider.request(target: .deleteDiary(year: year, month: month, date: date), instance: BaseResponse<EmptyResponseDTO>.self, completion: { data in
            guard let data = data.data else { return }
            self.getListData(year: year, month: month)
        })
    }
}
