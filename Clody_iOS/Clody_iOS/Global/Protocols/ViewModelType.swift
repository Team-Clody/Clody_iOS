//
//  ViewModelType.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/11/24.
//

import Foundation

import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output
}
