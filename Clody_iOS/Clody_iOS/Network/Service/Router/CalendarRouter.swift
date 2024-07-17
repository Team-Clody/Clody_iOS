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
}

extension CalendarRouter: BaseTargetType {
    var headers: [String : String]? {
        switch self {
        case .getMonthlyCalendar:
            return [
                APIConstants.contentType: APIConstants.applicationJSON,
                APIConstants.auth : APIConstants.Bearer + UserManager.shared.accessTokenValue
            ]
        case .getListCalendar:
            return [
                APIConstants.contentType: APIConstants.applicationJSON,
                APIConstants.auth : APIConstants.Bearer + UserManager.shared.accessTokenValue
            ]
        }
    }
    
    var path: String {
        switch self {
        case .getMonthlyCalendar:
            return "calendar"
        case .getListCalendar:
            return "calendar/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMonthlyCalendar, .getListCalendar:
            return .get
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
        }
    }
}
