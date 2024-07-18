//
//  DiaryRouter.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

import Moya

enum DiaryRouter {
    case getDailyDiary(year: Int, month: Int, date: Int)
    case deleteDiary(year: Int, month: Int, date: Int)
    case postDiary(data: PostDiaryRequestDTO)
    case getWritingTime(year: Int, month: Int, date: Int)
    case getReply(year: Int, month: Int, date: Int)
}

extension DiaryRouter: BaseTargetType {
    var headers: [String : String]? {
        switch self {
        case .getDailyDiary:
            return [
                APIConstants.contentType: APIConstants.applicationJSON,
                APIConstants.auth : APIConstants.Bearer + UserManager.shared.accessTokenValue
            ]
        case .deleteDiary:
            return [
                APIConstants.contentType: APIConstants.applicationJSON,
                APIConstants.auth : APIConstants.Bearer + UserManager.shared.accessTokenValue
            ]
        case .postDiary:
            return [
                APIConstants.contentType: APIConstants.applicationJSON,
                APIConstants.auth : APIConstants.Bearer + UserManager.shared.accessTokenValue
            ]
        case .getWritingTime:
            return [
                APIConstants.auth : APIConstants.Bearer + UserManager.shared.accessTokenValue
            ]
        case .getReply:
            return [
                APIConstants.contentType: APIConstants.applicationJSON,
                APIConstants.auth : APIConstants.Bearer + UserManager.shared.accessTokenValue
            ]
        }
    }
    
    var path: String {
        switch self {
        case .getDailyDiary, .postDiary, .deleteDiary:
            return "diary"
        case .getWritingTime:
            return "diary/time"
        case .getReply:
            return "reply"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDailyDiary, .getWritingTime, .getReply:
            return .get
        case .deleteDiary:
            return .delete
        case .postDiary:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getDailyDiary(year: let year, month: let month, date: let date):
            return .requestParameters(
                parameters: ["year": year, "month": month, "date": date],
                encoding: URLEncoding.queryString
            )
        case .deleteDiary(year: let year, month: let month, date: let date):
            return .requestParameters(
                parameters: ["year": year, "month": month, "date": date],
                encoding: URLEncoding.queryString
            )
        case .postDiary(let data):
            return .requestJSONEncodable(data)
        case .getWritingTime(year: let year, month: let month, date: let date):
            return .requestParameters(
                parameters: ["year": year, "month": month, "date": date],
                encoding: URLEncoding.queryString
            )
        case .getReply(year: let year, month: let month, date: let date):
            return .requestParameters(
                parameters: ["year": year, "month": month, "date": date],
                encoding: URLEncoding.queryString
            )
        }
    }
}
