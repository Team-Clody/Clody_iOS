//
//  LoginResponseDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct LoginResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
}
