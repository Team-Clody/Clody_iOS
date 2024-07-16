//
//  GetAlarmResponseDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct GetAlarmResponseDTO: Codable {
    let is_diaryAlarm: Bool
    let is_replyAlarm: Bool
    let time: String
}
