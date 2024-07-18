final class AuthInterceptor: RequestInterceptor {
    
    private var retryLimit = 1
    static let shared = AuthInterceptor()
    
    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("---adapter 진입----")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("-------🔧retry 시작🔧-------")
        
        guard let response = request.response, response.statusCode == 401, request.retryCount < retryLimit else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        NotificationCenter.default.post(name: .didStartTokenRefresh, object: nil)
        
        let provider = Providers.authProvider
        provider.request(.tokenRefresh) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200, let data = try? response.map(BaseResponse<TokenRefreshResponseDTO>.self), data.status == 200 {
                    if let tokenData = data.data {
                        UserManager.shared.updateToken(tokenData.accessToken, tokenData.refreshToken)
                        print("🪄토큰 재발급에 성공했습니다🪄")
                        NotificationCenter.default.post(name: .didFinishTokenRefresh, object: 200)
                        completion(.retry)
                    } else {
                        print("🚨토큰 데이터가 없습니다🚨")
//                        self.handleTokenRefreshFailure(error, completion: completion)
                    }
                } else {
                    print("🚨토큰 재발급에 실패했습니다🚨")
//                    self.handleTokenRefreshFailure(error, completion: completion)
                }
            case .failure(let moyaError):
                print("🚨토큰 재발급 중 오류 발생: \(moyaError)🚨")
                self.handleTokenRefreshFailure(moyaError, completion: completion)
            }
        }
    }
    
    private func handleTokenRefreshFailure(_ error: Error, completion: @escaping (RetryResult) -> Void) {
        UserManager.shared.clearAll()
        NotificationCenter.default.post(name: .didFinishTokenRefresh, object: 401)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.changeRootViewController(LoginViewController(), animated: true)
        }
        completion(.doNotRetryWithError(error))
    }
}

extension Notification.Name {
    static let didStartTokenRefresh = Notification.Name("didStartTokenRefresh")
    static let didFinishTokenRefresh = Notification.Name("didFinishTokenRefresh")
}

import UIKit
import Alamofire
import Moya

extension UIViewController {
    
    private struct AssociatedKeys {
        static var loadingIndicator = "loadingIndicator"
    }
    
    private var loadingIndicator: UIActivityIndicatorView {
        get {
            if let indicator = objc_getAssociatedObject(self, &AssociatedKeys.loadingIndicator) as? UIActivityIndicatorView {
                return indicator
            } else {
                let indicator = UIActivityIndicatorView(style: .large)
                indicator.hidesWhenStopped = true
                objc_setAssociatedObject(self, &AssociatedKeys.loadingIndicator, indicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return indicator
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadingIndicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func addTokenRefreshObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didStartTokenRefresh), name: .didStartTokenRefresh, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishTokenRefresh(_:)), name: .didFinishTokenRefresh, object: nil)
    }
    
    func removeTokenRefreshObservers() {
        NotificationCenter.default.removeObserver(self, name: .didStartTokenRefresh, object: nil)
        NotificationCenter.default.removeObserver(self, name: .didFinishTokenRefresh, object: nil)
    }
    
    @objc private func didStartTokenRefresh() {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
        }
    }
    
    @objc private func didFinishTokenRefresh(_ notification: Notification) {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            if let status = notification.object as? Int, status == 200 {
                self.reloadView()
            } else {
                self.handleTokenRefreshFailure()
            }
        }
    }
    
    @objc func reloadView() {
        // 뷰 리로드 로직 추가
        print("뷰 리로드")
    }
    
    @objc func handleTokenRefreshFailure() {
        // 토큰 재발급 실패 시 처리 로직 추가
        print("토큰 재발급 실패")
    }
}
