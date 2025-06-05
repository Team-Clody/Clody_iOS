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
    case draft
    case draft_done

    var image: UIImage? {
        switch self {
        case .none: return UIImage(named: "clover0")
        case .one: return UIImage(named: "clover1")
        case .two: return UIImage(named: "clover2")
        case .three: return UIImage(named: "clover3")
        case .four: return UIImage(named: "clover4")
        case .five: return UIImage(named: "clover5")
        case .today: return UIImage(named: "cloverToday")
        case .todayDone: return UIImage(named: "cloverTodayDone")
        case .draft: return .cloverDraft
        case .draft_done: return .cloverDraftExpired
        }
    }

    static func fromDiaryCount(_ count: Int) -> CloverType {
        return CloverType(rawValue: count) ?? .none
    }
}
