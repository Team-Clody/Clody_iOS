//
//  SignUpResponseDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation

struct SignUpResponseDTO: Codable {
    let userId: Int
    let accessToken: String
    let refreshToken: String
}
