//
//  CalendarRouter.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation

import Moya

enum CalendarRouter {
    case getDummyData
}

extension CalendarRouter: BaseTargetType {
    var headers: [String : String]? {
        switch self {
        case .getDummyData:
            return APIConstants.hasTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .getDummyData:
            return "dummy/app"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDummyData:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getDummyData:
            return .requestPlain
        }
    }
}
