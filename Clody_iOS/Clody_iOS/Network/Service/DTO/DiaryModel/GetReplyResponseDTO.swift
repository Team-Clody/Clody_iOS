//
//  GetReplyDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct GetReplyResponseDTO: Codable {
    let content: String
    let nickname: String
    let month: Int
    let date: Int
    let isRead: Bool
}
