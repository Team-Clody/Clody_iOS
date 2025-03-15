//
//  GetWritingTimeResponseDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct GetWritingTimeResponseDTO: Codable {
    let HH: Int
    let mm: Int
    let ss: Int
    let date: String
    let isFirst: Bool
    let isFromAd: Bool
}
