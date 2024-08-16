//
//  SignUpRequestDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation

struct SignUpRequestDTO: Codable {
    let platform: String
    let email: String
    let name: String
}
