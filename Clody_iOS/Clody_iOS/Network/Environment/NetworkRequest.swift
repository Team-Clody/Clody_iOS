//
//  NetworkRequest.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation
import Moya

struct ResponseData<Model: Codable> {
    struct CommonResponse: Codable {
        let result: Model
    }

    static func processResponse(_ result: Result<Response, MoyaError>) -> Result<Model?, Error> {
        switch result {
        case .success(let response):
            do {
                // status code가 200...299인 경우만 success로 체크 (아니면 예외발생)
                _ = try response.filter(statusCodes: 200...500)

                let commonResponse = try JSONDecoder().decode(CommonResponse.self, from: response.data)
                return .success(commonResponse.result)
            } catch {
                return .failure(error)
            }

        case .failure(let error):
            return .failure(error)
        }
    }
    
}
