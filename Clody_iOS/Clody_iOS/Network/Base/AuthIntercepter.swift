//
//  AuthIntercepter.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation

import Alamofire
import Moya
import UIKit

///// 토큰 만료 시 자동으로 refresh를 위한 서버 통신
final class AuthInterceptor: RequestInterceptor {
    
    private var retryLimit = 2
    static let shared = AuthInterceptor()
    
    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("---adater 진입----")
        // 여기에 토큰 추가 등 요청 수정 작업을 수행할 수 있습니다.
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("-------🔧retry 시작🔧-------")
        
        guard let response = request.response, response.statusCode == 401, request.retryCount < retryLimit else {
            print("🚨재시도 횟수가 너무 많습니다🚨")
            completion(.doNotRetryWithError(error))
            return
        }
        
        let provider = MoyaProvider<AuthRouter>()
        provider.request(.tokenRefresh) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200, let data = try? response.map(BaseResponse<EmptyResponseDTO>.self), data.status == 200 {
                    // 갱신된 토큰을 저장하는 로직 추가
                    if let tokenData = data.data {
                        // UserManager.shared.updateToken(tokenData.token.accessToken, tokenData.token.refreshToken)
                        print("🪄토큰 재발급에 성공했습니다🪄")
                        completion(.retry)
                    } else {
                        print("🚨토큰 데이터가 없습니다🚨")
                        // 로그아웃 처리 필요
                        // UserManager.shared.logout()
                        completion(.doNotRetryWithError(error))
                    }
                } else {
                    print("🚨토큰 재발급에 실패했습니다🚨")
                    // 로그아웃 처리 필요
                    // UserManager.shared.logout()
                    completion(.doNotRetryWithError(error))
                }
            case .failure(let moyaError):
                print("🚨토큰 재발급 중 오류 발생: \(moyaError)🚨")
                completion(.doNotRetryWithError(moyaError))
            }
        }
    }
}
