//
//  PostDiaryRequestDTo.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct PostDiaryRequestDTO: Codable {
    let date: String
    let content: [String]
}