//
//  LoginRequestDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct LoginRequestDTO: Codable {
    let platform: String
    let fcmToken: String
}
