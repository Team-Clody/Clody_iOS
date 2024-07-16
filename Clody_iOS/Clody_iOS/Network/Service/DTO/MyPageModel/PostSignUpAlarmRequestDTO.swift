//
//  PostSignUpAlarmRequestDTO.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation

struct PostSignUpAlarmRequestDTO: Codable {
    let fcmToken: String
    let time: String
}
