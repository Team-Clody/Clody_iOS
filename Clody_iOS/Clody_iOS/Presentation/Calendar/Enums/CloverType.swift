//
//  CloverType.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/3/25.
//

import UIKit

enum CloverType: Int {
    case none = 0
    case one
    case two
    case three
    case four
    case five
    case today
    case todayDone
    case hasDraft
    case draftDone

    var image: UIImage? {
        switch self {
        case .none: return .clover0
        case .one: return .clover1
        case .two: return .clover2
        case .three: return .clover3
        case .four: return .clover4
        case .five: return .clover5
        case .today: return .cloverToday
        case .todayDone: return .cloverTodayDone
        case .hasDraft: return .cloverDraft
        case .draftDone: return .cloverDraftExpired
        }
    }

    static func fromDiaryCount(_ count: Int) -> CloverType {
        return CloverType(rawValue: count) ?? .none
    }
}
