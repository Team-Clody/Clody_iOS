//
//  BaseModel.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    var status: Int
    var message: String?
    var data: T?
}
