//
//  CalendarRouter.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation

import Moya

enum CalendarRouter {
    case getMonthlyCalendar(year: Int, month: Int)
    case getListCalendar(year: Int, month: Int)
    case getDailyDiary(year: Int, month: Int, dat: Int)
    case deleteDiary(year: Int, month: Int, dat: Int)
}

extension CalendarRouter: BaseTargetType {
    var headers: [String : String]? {
        switch self {
        case .getMonthlyCalendar:
            return APIConstants.hasTokenHeader
        case .getListCalendar:
            return APIConstants.hasTokenHeader
        case .getDailyDiary:
            return APIConstants.hasTokenHeader
        case .deleteDiary:
            return APIConstants.hasTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .getMonthlyCalendar:
            return "calender"
        case .getListCalendar:
            return "calender/list"
        case .getDailyDiary:
            return "diary"
        case .deleteDiary:
            return "diary"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMonthlyCalendar, .getListCalendar, .getDailyDiary:
            return .get
        case .deleteDiary:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMonthlyCalendar(let year, let month):
            return .requestParameters(
                parameters: ["year": year, "month": month],
                encoding: URLEncoding.queryString
            )
        case .getListCalendar(year: let year, month: let month):
            return .requestParameters(
                parameters: ["year": year, "month": month],
                encoding: URLEncoding.queryString
            )
        case .getDailyDiary(year: let year, month: let month, dat: let date):
            return .requestParameters(
                parameters: ["year": year, "month": month, "date": date],
                encoding: URLEncoding.queryString
            )
        case .deleteDiary(year: let year, month: let month, dat: let date):
            return .requestParameters(
                parameters: ["year": year, "month": month, "day": date],
                encoding: URLEncoding.queryString
            )
        }
    }
}
