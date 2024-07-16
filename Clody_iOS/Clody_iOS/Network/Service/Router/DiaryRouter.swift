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
            return APIConstants.hasTokenHeader
        case .deleteDiary:
            return APIConstants.hasTokenHeader
        case .postDiary:
            return APIConstants.hasTokenHeader
        case .getWritingTime:
            return APIConstants.hasTokenHeader
        case .getReply:
            return APIConstants.hasTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .getDailyDiary, .postDiary, .deleteDiary:
            return "diary"
        case .getWritingTime(year: let year, month: let month, date: let date):
            return "diary/time"
        case .getReply(year: let year, month: let month, date: let date):
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
