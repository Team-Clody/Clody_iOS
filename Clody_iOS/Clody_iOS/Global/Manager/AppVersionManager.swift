//
//  AppVersionManager.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 8/18/24.
//

import UIKit

class AppVersionManager {
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
                        
                        if appStoreVersion.compare(currentVersion, options: .numeric) == .orderedDescending {
                            // 앱스토어 버전이 더 최신인 경우 업데이트 알림 띄우기
                            DispatchQueue.main.async {
                                self.showUpdateAlert(appStoreVersion: appStoreVersion, completion: completion)
                            }
                        } else {
                            completion(true) // 최신 버전인 경우 계속 진행
                        }
                    } else {
                        completion(true) // JSON 파싱 오류가 발생한 경우 계속 진행
                    }
                }
                task.resume()
            } else {
                completion(true) // URL 오류가 발생한 경우 계속 진행
            }
        }
        
        private func showUpdateAlert(appStoreVersion: String, completion: @escaping (Bool) -> Void) {
            guard let topViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
            
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
