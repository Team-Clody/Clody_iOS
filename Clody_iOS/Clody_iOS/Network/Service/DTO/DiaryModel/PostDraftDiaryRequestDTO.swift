//
//  PostDraftDiaryRequestDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/6/25.
//

import Foundation

struct PostDraftDiaryRequestDTO: Codable {
    let date: String
    let draftDiaries: [String]
}
