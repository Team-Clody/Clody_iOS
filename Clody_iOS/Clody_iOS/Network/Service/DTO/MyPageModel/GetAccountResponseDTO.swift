//
//  GetAccountResponseDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct GetAccountResponseDTO: Codable {
    let email: String
    let name: String
    let platform: String
}
