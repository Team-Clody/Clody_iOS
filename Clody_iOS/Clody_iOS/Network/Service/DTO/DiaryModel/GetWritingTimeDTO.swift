//
//  GetWritingTimeDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct GetWritingTimeDTO: Codable {
    let HH: Int
    let mm: Int
    let ss: Int
    let isFirst: Bool
}
