//
//  AppVersionManager.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 8/18/24.
//

import UIKit

class AppVersionManager {
    
    private enum UpdateType {
        case force, optional, none
    }
    
    static let shared = AppVersionManager()
    
    func checkForUpdateAndProceed(completion: @escaping (Bool) -> Void) {
        if let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(Bundle.main.bundleIdentifier!)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completion(true) // 네트워크 오류가 발생한 경우 계속 진행
                    return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let appStoreVersion = results.first?["version"] as? String {
                    
                    let currentVersion = self.currentAppVersion()
                    
                    switch self.compareVersion(currentVersion, appStoreVersion) {
                    case .force:
                        DispatchQueue.main.async {
                            self.showForceUpdateAlert(appStoreVersion: appStoreVersion)
                            completion(false)
                        }
                    case .optional:
                        DispatchQueue.main.async {
                            self.showOptionalUpdateAlert(appStoreVersion: appStoreVersion, completion: completion)
                        }
                    case .none:
                        completion(true)
                    }
                } else {
                    completion(true)
                }
            }
            task.resume()
        } else {
            completion(true) // URL 오류가 발생한 경우 계속 진행
        }
    }
    
    private func compareVersion(_ current: String, _ store: String) -> UpdateType {
        let currentComponents = current.split(separator: ".").map { Int($0) ?? 0 }
        let storeComponents = store.split(separator: ".").map { Int($0) ?? 0 }
        
        for i in 0..<3 {
            let currentPart = currentComponents[i]
            let storePart = storeComponents[i]
            
            if storePart > currentPart {
                return i == 2 ? .optional : .force
            } else if storePart < currentPart {
                return .none
            }
        }
        return .none
    }
    
    private func showForceUpdateAlert(appStoreVersion: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let topViewController = windowScene.windows.first?.rootViewController else { return }
        
        let alert = UIAlertController(
            title: "필수 업데이트",
            message: "버전 \(appStoreVersion)으로 업데이트가 필요합니다.",
            preferredStyle: .alert
        )
        
        let updateAction = UIAlertAction(title: "업데이트", style: .default) { _ in
            self.openAppStore()
        }
        
        let exitAction = UIAlertAction(title: "앱 종료", style: .destructive) { _ in
            exit(0)
        }
        
        alert.addAction(updateAction)
        alert.addAction(exitAction)
        
        topViewController.present(alert, animated: true, completion: nil)
    }
    
    private func showOptionalUpdateAlert(appStoreVersion: String, completion: @escaping (Bool) -> Void) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let topViewController = windowScene.windows.first?.rootViewController else { return }
        
        let alert = UIAlertController(title: "업데이트 필요",
                                      message: "새로운 버전 \(appStoreVersion)을 사용할 수 있습니다. 지금 업데이트하시겠습니까?",
                                      preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "업데이트", style: .default) { _ in
            self.openAppStore()
            completion(false) // 업데이트를 선택한 경우 스플래시에서 중지
        }
        
        let cancelAction = UIAlertAction(title: "나중에", style: .cancel) { _ in
            completion(true) // 나중에를 선택한 경우
        }
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        
        topViewController.present(alert, animated: true, completion: nil)
    }
    
    private func openAppStore() {
        if let url = URL(string: I18N.Common.appLink) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func currentAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "최신 버전"
    }
}
