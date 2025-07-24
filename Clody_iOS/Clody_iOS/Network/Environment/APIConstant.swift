//
//  APIConstant.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation
import Moya

struct APIConstants{
    static let contentType = "Content-Type"
    static let applicationJSON = "application/json"
    static let auth = "Authorization"
    static let access = "accessToken"
    static let refresh = "refreshToken"
    static let accessToken = "Bearer " + ""
    static let refreshToken = "Bearer " + ""
    static var authCode = ""
    static let Bearer = "Bearer "
    static let timeZone = "Time-Zone"
    static let acceptLanguage = "Accept-Language"
}

extension APIConstants{
    static var authCodeHeader: [String: String] {
        [contentType: applicationJSON,
                auth: Bearer + authCode]
    }
    
    static var accessTokenHeader: [String: String] {
        [contentType: applicationJSON,
                auth: Bearer + UserManager.shared.accessTokenValue]
    }
    
    static var refreshTokenHeader: [String: String] {
        [auth: Bearer + UserManager.shared.refreshTokenValue]
    }
    
    static var postDiaryHeader: [String: String] {
        [contentType: applicationJSON,
                auth: Bearer + UserManager.shared.accessTokenValue,
            timeZone: LocalizationConstant.timeZoneCode,
      acceptLanguage: LocalizationConstant.Calendar.calendarLocale.identifier
        ]
    }
}
