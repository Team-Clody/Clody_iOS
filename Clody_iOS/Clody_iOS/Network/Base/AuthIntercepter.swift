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
        print("---adapter 진입----")
        
        var adaptedRequest = urlRequest
        let isSignIn: Bool = urlRequest.url?.path.contains("/signin") ?? false
        let isSignUp: Bool = urlRequest.url?.path.contains("/signup") ?? false
        
        if isSignIn || isSignUp {
            adaptedRequest.setValue(APIConstants.Bearer + APIConstants.authCode, forHTTPHeaderField: APIConstants.auth)
        } else {
            if let accessToken = UserManager.shared.accessToken {
                adaptedRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: APIConstants.auth)
            }
        }
     
        completion(.success(adaptedRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("-------🔧retry 시작🔧-------")
        
        if request.retryCount >= retryLimit {
            print("🚨재시도 횟수가 너무 많습니다🚨")
            completion(.doNotRetryWithError(error))
            return
        }
        
        guard let response = request.response, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        let provider = MoyaProvider<AuthRouter>()
        provider.request(.tokenRefresh) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200, let data = try? response.map(BaseResponse<TokenRefreshResponseDTO>.self), data.status == 200 {
                    if let tokenData = data.data {
                        UserManager.shared.updateToken(tokenData.accessToken, tokenData.refreshToken)
                        print("🪄토큰 재발급에 성공했습니다🪄")
                        completion(.retry)
                    } else {
                        print("🚨토큰 데이터가 없습니다🚨")
                        self.handleTokenRefreshFailure(completion: completion, error: error)
                    }
                } else {
                    print("🚨토큰 재발급에 실패했습니다🚨")
                    self.handleTokenRefreshFailure(completion: completion, error: error)
                }
            case .failure(let moyaError):
                print("🚨토큰 재발급 중 오류 발생: \(moyaError)🚨")
                self.handleTokenRefreshFailure(completion: completion, error: moyaError)
            }
        }
    }
    
    private func handleTokenRefreshFailure(completion: @escaping (RetryResult) -> Void, error: Error) {
        UserManager.shared.clearAll()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.changeRootViewController(LoginViewController(), animated: true)
        }
        completion(.doNotRetryWithError(error))
    }
}
