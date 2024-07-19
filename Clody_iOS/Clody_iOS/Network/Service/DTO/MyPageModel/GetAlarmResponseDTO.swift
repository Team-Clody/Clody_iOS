//
//  GetAlarmResponseDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct GetAlarmResponseDTO: Codable {
    let isDiaryAlarm: Bool
    let isReplyAlarm: Bool
    let time: String
}

struct AlarmModel {
    var isDiaryAlarm: Bool
    var isReplyAlarm: Bool
    var time: String
}
