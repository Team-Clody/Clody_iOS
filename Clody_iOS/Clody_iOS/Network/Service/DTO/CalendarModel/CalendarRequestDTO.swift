//
//  CalendarRequestDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation

struct SocialLogineResponseDTO: Codable {
    let userId: Int
    let token: Token
}

struct Token: Codable {
    let accessToken: String
    let refreshToken: String
}
