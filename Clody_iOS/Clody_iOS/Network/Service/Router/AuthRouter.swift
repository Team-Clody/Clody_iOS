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
    case login(data: LoginRequestDTO)
    case tokenRefresh
    case logout
    case revoke
}

extension AuthRouter: BaseTargetType {
    var headers: Parameters? {
        switch self {
        case .signUp:
            return APIConstants.authCodeHeader
        case .login:
            return APIConstants.authCodeHeader
        case .tokenRefresh:
            return APIConstants.hasRefreshTokenHeader
        case .logout:
            return APIConstants.hasTokenHeader
        case .revoke:
            return APIConstants.hasTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "auth/signup"
        case .login:
            return "auth/signin"
        case .tokenRefresh:
            return "reissue"
        case .logout:
            return "logout"
        case .revoke:
            return "revoke"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .login:
            return .post
        case .tokenRefresh, .logout:
            return .get
        case .revoke:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let data):
            return .requestJSONEncodable(data)
        case .login(let data):
            return .requestJSONEncodable(data)
        case .tokenRefresh:
            return .requestPlain
        case .logout:
            return .requestPlain
        case .revoke:
            return .requestPlain
        }
    }
}
