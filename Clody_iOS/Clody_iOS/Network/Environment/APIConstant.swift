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
    static let accessToken = "Bearer " + "UserManager.shared.accessTokenValue"
    static let refreshToken = "Bearer " + "UserManager.shared.refreshTokenValue"
    static let appleAccessToken = "UserManager.shared.appleTokenValue"
    static let OS = "OS"
    static let iOS = "iOS"
}

extension APIConstants{
    static let hasSocialTokenHeader = [contentType: applicationJSON,
                                       auth : appleAccessToken]
    static let hasTokenHeader = [contentType: applicationJSON,
                                          OS: iOS,
                                       auth : accessToken]
    static let hasRefreshTokenHeader = [contentType: applicationJSON,
                                       auth : refreshToken]
    static let signUpHeader = [contentType: applicationJSON,
                                       auth : appleAccessToken,
                                        OS: iOS,]
}

