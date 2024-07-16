//
//  PostAlarmSetResponseDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct PostAlarmSetResponseDTO: Codable {
    let isDiaryAlarm: Bool
    let isReplyAlarm: Bool
    let time: String
    let fcmToken: String
}
