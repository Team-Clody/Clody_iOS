//
//  SignUpRequestDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation

struct SignUpRequestDTO: Codable {
    let plaform: String
    let email: String
    let nickname: String
    let id_token: String
}
