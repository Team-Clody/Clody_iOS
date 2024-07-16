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
    case signIn(data: LoginRequestDTO)
    case tokenRefresh
    case logout
    case revoke
}

extension AuthRouter: BaseTargetType {
    var headers: Parameters? {
        switch self {
        case .signUp:
            return APIConstants.authCodeHeader
        case .signIn:
            return APIConstants.authCodeHeader
        case .tokenRefresh:
            return [
                APIConstants.contentType: APIConstants.applicationJSON,
                APIConstants.auth : APIConstants.Bearer + UserManager.shared.refreshTokenValue
            ]
        case .logout:
            return APIConstants.hasTokenHeader
        case .revoke:
            return [
                APIConstants.auth : APIConstants.Bearer + UserManager.shared.accessTokenValue
            ]
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "auth/signup"
        case .signIn:
            return "auth/signin"
        case .tokenRefresh:
            return "auth/reissue"
        case .logout:
            return "logout"
        case .revoke:
            return "user/revoke"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .signIn:
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
        case .signIn(let data):
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
