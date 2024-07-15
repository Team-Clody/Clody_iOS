//
//  AuthRouter.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation

import Moya

enum AuthRouter {
    case signUp(data: SignUpRequestDTO)
    case tokenRefresh
}

extension AuthRouter: BaseTargetType {
    var headers: Parameters? {
        switch self {
        case .signUp:
            return APIConstants.authCodeHeader
        case .tokenRefresh:
            return APIConstants.hasRefreshTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "auth/signup"
        case .tokenRefresh:
            return "reissue"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp:
            return .post
        case .tokenRefresh:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let data):
            return .requestJSONEncodable(data)
        case .tokenRefresh:
            return .requestPlain
        }
    }
    
    var validationType: ValidationType {
        switch self {
        case .signUp(data:_):
            return .successCodes
        case .tokenRefresh:
            return .successCodes
        }
    }
}
