//
//  CalendarDailyModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/5/24.
//

import Foundation

struct CalendarDailyModel {
    let date: String
    let status: String
    let diary: [String]
}

extension CalendarDailyModel {
    static func dummy(dateString: String) -> CalendarDailyModel {
        let possibleDiaries = [
            "마지막이라 감사해. 정말~",
            "마지막이라 감사해. 정말~어쩌구, 2. 마지막이라 감사해. 정말~어쩌구,마지막이라 감사해. 정말~어쩌구, 마지막이라 감사해. 정말~어쩌구,",
            "마지막이라 감사해. 정말~어쩌구, 2. 마지막이라 감사해. 정말~어쩌구,마지막이라 감사해. 정말~어쩌구, 마지막이라 감사해. 정말~어쩌구,",
            "마지막이라 감사해. 정말~어쩌구, 2. 마지막이라 감사해. 정말~어쩌구,마지막이라 감사해. 정말~어쩌구, 마지막이라 감사해. 정말~어쩌구,",
            "마지막이라 감사해. 정말~어쩌구, 2. 마지막이라 감사해. 정말~어쩌구,마지막이라 감사해. 정말~어쩌구, 마지막이라 감사해. 정말~어쩌구,",
        ]
        
        // 0에서 5개의 다이어리 항목을 무작위로 선택
        let numberOfDiaries = Int.random(in: 0...5)
        let diaries = (0..<numberOfDiaries).map { _ in
            possibleDiaries.randomElement()!
        }
        
        let status = "\(Int.random(in: 0...3))"
        
        return CalendarDailyModel(date: dateString, status: status, diary: diaries)
    }
}
