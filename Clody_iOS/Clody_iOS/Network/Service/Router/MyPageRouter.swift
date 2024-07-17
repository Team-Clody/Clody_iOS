//
//  AlarmRouter.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

import Moya

enum MyPageRouter {
    case getAlarmSet
    case postAlarmSet(data: PostAlarmSetRequestDTO)
    case getAccount
    case patchNickname(data: PatchNicknameRequestDTO)
}

extension MyPageRouter: BaseTargetType {
    var headers: [String : String]? {
        switch self {
        case .getAlarmSet:
            return [
                APIConstants.contentType: APIConstants.applicationJSON,
                APIConstants.auth : APIConstants.Bearer + UserManager.shared.accessTokenValue
            ]
        case .postAlarmSet:
            return [
                APIConstants.contentType: APIConstants.applicationJSON,
                APIConstants.auth : APIConstants.Bearer + UserManager.shared.accessTokenValue
            ]
        case .getAccount:
            return [
                APIConstants.contentType: APIConstants.applicationJSON,
                APIConstants.auth : APIConstants.Bearer + UserManager.shared.accessTokenValue
            ]
        case .patchNickname:
            return [
                APIConstants.contentType: APIConstants.applicationJSON,
                APIConstants.auth : APIConstants.Bearer + UserManager.shared.accessTokenValue
            ]
        }
    }
    
    var path: String {
        switch self {
        case .getAlarmSet:
            return "alarm"
        case .postAlarmSet:
            return "alarm"
        case .getAccount:
            return "user/info"
        case .patchNickname:
            return "user/nickname"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postAlarmSet:
            return .post
        case .getAlarmSet, .getAccount:
            return .get
        case .patchNickname:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAlarmSet:
            return .requestPlain
        case .postAlarmSet(let data):
            return .requestJSONEncodable(data)
        case .getAccount:
            return .requestPlain
        case .patchNickname(let data):
            return .requestJSONEncodable(data)
        }
    }
}

