//
//  GetAlarmResponseDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct GetAlarmResponseDTO: Codable {
    let fcmToken: String
    let isDiaryAlarm: Bool
    let isReplyAlarm: Bool
    let time: String
}
