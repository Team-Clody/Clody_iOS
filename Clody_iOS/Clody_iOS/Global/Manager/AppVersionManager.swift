//
//  AppVersionManager.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 8/18/24.
//

import UIKit

class AppVersionManager {
    static let shared = AppVersionManager()
    
    func checkForUpdate() {
        // 앱스토어의 최신 버전 정보 확인
        if let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(Bundle.main.bundleIdentifier!)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let appStoreVersion = results.first?["version"] as? String {
                    
                    let currentVersion = self.currentAppVersion()
                    
                    if appStoreVersion.compare(currentVersion, options: .numeric) == .orderedDescending {
                        // 앱스토어 버전이 더 최신인 경우 업데이트 알림 띄우기
                        DispatchQueue.main.async {
                            self.showUpdateAlert(appStoreVersion: appStoreVersion)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func showUpdateAlert(appStoreVersion: String) {
        guard let topViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
        
        let alert = UIAlertController(title: "업데이트 필요",
                                      message: "새로운 버전 \(appStoreVersion)을 사용할 수 있습니다. 지금 업데이트하시겠습니까?",
                                      preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "업데이트", style: .default) { _ in
            self.openAppStore()
        }
        
        let cancelAction = UIAlertAction(title: "나중에", style: .cancel, handler: nil)
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        
        topViewController.present(alert, animated: true, completion: nil)
    }
    
    private func openAppStore() {
        if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") {
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
