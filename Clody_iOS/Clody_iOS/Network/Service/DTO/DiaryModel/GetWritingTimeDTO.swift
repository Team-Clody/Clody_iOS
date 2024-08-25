//
//  GetWritingTimeDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct GetWritingTimeDTO: Codable {
    let HH: Int
    let MM: Int
    let SS: Int
    let isFirst: Bool
}
