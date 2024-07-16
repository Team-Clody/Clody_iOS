//
//  SignUpRequestDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation

struct SignUpRequestDTO: Codable {
    let platform: String
    let name: String
}

// 애플 로그인 필요 요소 DTO

//struct SignUpRequestDTO: Codable {
//    let platform: String
//    let email: String
//    let name: String
//    let id_token: String
//}
