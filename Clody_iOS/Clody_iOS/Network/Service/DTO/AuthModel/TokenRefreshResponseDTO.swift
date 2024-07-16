//
//  TokenRefreshResponseDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct TokenRefreshResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
}
