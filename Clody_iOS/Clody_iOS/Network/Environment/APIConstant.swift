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
    static let accessToken = "Bearer " + "yJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MjEyMzA0NjQsImV4cCI6MTcyMTIzMDY0NCwidHlwZSI6ImFjY2VzcyIsInVzZXJJZCI6NDB9.WDb4kMABmels4DXs2gQntAOSLjyoOVaui3GLmEIPcdw"
    static let refreshToken = "Bearer " + ""
    static var authCode = ""
    static let Bearer = "Bearer "
}

extension APIConstants{
    static let authCodeHeader = [contentType: applicationJSON,
                                        auth: Bearer + authCode]
    static let hasTokenHeader = [contentType: applicationJSON,
                                        auth: accessToken]
    static let hasRefreshTokenHeader = [contentType: applicationJSON]
}

