//
//  AlarmRouter.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

import Moya

enum MyPageRouter {
    case postSignUpAlarm(data: PostSignUpAlarmRequestDTO)
    case getAlarmSet
    case postAlarmSet(data: PostAlarmSetRequestDTO)
    case getAccount
    case patchNickname(data: PatchNicknameRequestDTO)
}

extension MyPageRouter: BaseTargetType {
    var headers: [String : String]? {
        switch self {
        case .postSignUpAlarm:
            return APIConstants.hasTokenHeader
        case .getAlarmSet:
            return APIConstants.hasTokenHeader
        case .postAlarmSet:
            return APIConstants.hasTokenHeader
        case .getAccount:
            return APIConstants.hasTokenHeader
        case .patchNickname:
            return APIConstants.hasTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .postSignUpAlarm:
            return "alarm/diary"
        case .getAlarmSet:
            return "alarm/diary"
        case .postAlarmSet:
            return "alarm/diary"
        case .getAccount:
            return "user/info"
        case .patchNickname:
            return "user/nickname"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSignUpAlarm, .postAlarmSet:
            return .post
        case .getAlarmSet, .getAccount:
            return .get
        case .patchNickname:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postSignUpAlarm(let data):
            return .requestJSONEncodable(data)
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

