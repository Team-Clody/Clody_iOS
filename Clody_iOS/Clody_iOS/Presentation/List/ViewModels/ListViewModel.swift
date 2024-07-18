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
    }
    
    let listDataRelay = BehaviorRelay<CalendarListResponseDTO>(value: CalendarListResponseDTO(totalMonthlyCount: 0, diaries: []))
    let selectedMonthRelay = BehaviorRelay<[String]>(value: ["", ""])
    private let selectedDateRelay = BehaviorRelay<String?>(value: nil)
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let today = Date()
                let year = DateFormatter.string(from: today, format: "yyyy")
                let month = DateFormatter.string(from: today, format: "M")

                getListData(year: Int(year) ?? 0, month: Int(month) ?? 0)
                selectedMonthRelay.accept([year, month])
            })
            .disposed(by: disposeBag)
        
        input.tapKebabButton
             .emit(onNext: { [weak self] date in
                 self?.selectedDateRelay.accept(date)
             })
             .disposed(by: disposeBag)
        
        input.tapDeleteButton
            .emit(onNext: { [weak self] in
                guard let self = self, let date = self.selectedDateRelay.value else { return }
                let dateComponents = date.split(separator: "-").map { Int($0) ?? 0 }
                if dateComponents.count == 3 {
                    let year = dateComponents[0]
                    let month = dateComponents[1]
                    let day = dateComponents[2]
                    // Alert에 붙여야 함.
                    self.deleteDiary(year: year, month: month, date: day)
                }
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
            .map { date -> String in
                let dateSelected = "\(date[0])년 \(date[1])월"
                return dateSelected
            }
            .asDriver(onErrorJustReturn: "Error")
        
        return Output(
            replyDate: replyDate,
            kebabDate: kebabDate,
            changeToCalendar: changeToCalendar,
            showPickerView: showPickerView,
            changeNavigationDate: changeNavigationDate, 
            listDataChanged: listDataChanged
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
        
        self.selectedMonthRelay.accept([String(year), String(month)])
    }
    
    func deleteDiary(year: Int, month: Int, date: Int) {
        let provider = Providers.diaryRouter

        provider.request(target: .deleteDiary(year: year, month: month, date: date), instance: BaseResponse<EmptyResponseDTO>.self, completion: { data in
            guard let data = data.data else { return }
            
        })
    }
}
