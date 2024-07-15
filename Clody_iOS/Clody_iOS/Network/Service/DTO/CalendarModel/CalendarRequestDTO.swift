//
//  CalendarRequestDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation

struct CalendarRequestDTO: Codable {
    let userId: Int
    let token: Token
}

struct Token: Codable {
    let accessToken: String
    let refreshToken: String
}
