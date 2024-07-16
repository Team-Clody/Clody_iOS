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
    static let accessToken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MjExMTc2NjEsImV4cCI6MTcyMTExODg2MSwidHlwZSI6ImFjY2VzcyIsInVzZXJJZCI6MTd9.Du_ND3JLQsVcpJqMUfceLLdbjS9sDSsV2SHt-drfd-E"
    static let refreshToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MjExMDYwODEsImV4cCI6MTcyMjMxNTY4MSwidHlwZSI6InJlZnJlc2giLCJ1c2VySWQiOjJ9.ZlUlXnLVIZnRV5D96GllQZ22jRBfBxA2nyXOHXGmzB0"
    static let authCode = "Bearer " + ""
}

extension APIConstants{
    static let authCodeHeader = [contentType: applicationJSON,
                                       auth : authCode]
    static let hasTokenHeader = [contentType: applicationJSON,
                                       auth : accessToken]
    static let hasRefreshTokenHeader = [contentType: applicationJSON]
}

