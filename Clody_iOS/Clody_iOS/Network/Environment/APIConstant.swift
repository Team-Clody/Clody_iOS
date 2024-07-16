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
    static let accessToken = "Bearer " + "UserManager.shared.accessTokenValue"
    static let refreshToken = "Bearer " + "UserManager.shared.refreshTokenValue"
    static let authCode = "Bearer " + ""
}

extension APIConstants{
    static let authCodeHeader = [contentType: applicationJSON,
                                       auth : authCode]
    static let hasTokenHeader = [contentType: applicationJSON,
                                       auth : accessToken]
    static let hasRefreshTokenHeader = [contentType: applicationJSON]
}

