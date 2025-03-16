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
    case postAdStart(data: PostPatchAdRequestDTO)
    case patchAdEnd(data: PostPatchAdRequestDTO)
    case getReply(year: Int, month: Int, date: Int)
}

extension DiaryRouter: BaseTargetType {
    var headers: [String : String]? {
        switch self {
        case .getDailyDiary:
            return APIConstants.accessTokenHeader
        case .deleteDiary:
            return APIConstants.accessTokenHeader
        case .postDiary:
            return APIConstants.accessTokenHeader
        case .getWritingTime:
            return APIConstants.accessTokenHeader
        case .postAdStart:
            return APIConstants.accessTokenHeader
        case .patchAdEnd:
            return APIConstants.accessTokenHeader
        case .getReply:
            return APIConstants.accessTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .getDailyDiary, .postDiary, .deleteDiary:
            return "diary"
        case .getWritingTime:
            return "diary/time"
        case .postAdStart:
            return "reply/ad/start"
        case .patchAdEnd:
            return "reply/ad/end"
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
        case .postAdStart:
            return .post
        case .patchAdEnd:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getDailyDiary(let year, let month, let date):
            return .requestParameters(
                parameters: ["year": year, "month": month, "date": date],
                encoding: URLEncoding.queryString
            )
        case .deleteDiary(let year, let month, let date):
            return .requestParameters(
                parameters: ["year": year, "month": month, "date": date],
                encoding: URLEncoding.queryString
            )
        case .postDiary(let data):
            return .requestJSONEncodable(data)
        case .getWritingTime(let year, let month, let date):
            return .requestParameters(
                parameters: ["year": year, "month": month, "date": date],
                encoding: URLEncoding.queryString
            )
        case .postAdStart(let data):
            return .requestJSONEncodable(data)
        case .patchAdEnd(let data):
            return .requestJSONEncodable(data)
        case .getReply(let year, let month, let date):
            return .requestParameters(
                parameters: ["year": year, "month": month, "date": date],
                encoding: URLEncoding.queryString
            )
        }
    }
}
