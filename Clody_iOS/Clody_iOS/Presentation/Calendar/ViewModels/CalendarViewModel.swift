//
//  CalendarViewModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/28/24.
//

import UIKit

import RxSwift

protocol CalendarViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output
}

final class CalendarViewModel: CalendarViewModelType {

    struct Input {
    }

    struct Output {
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        return output
    }
}
