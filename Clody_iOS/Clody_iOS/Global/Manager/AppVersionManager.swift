//
//  AppVersionManager.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 8/18/24.
//

import UIKit
import FirebaseRemoteConfig

class AppVersionManager {
    
    enum UpdateType {
        case force, optional, none
    }
    
    static let shared = AppVersionManager()
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    private let latestVersion: String?
    private let currentVersion: String?
    var version: String {
        guard let latestVersion, let currentVersion else { return  "" }
        return latestVersion == currentVersion ? .Setting.latestVersion : currentVersion
    }
    
    private init() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 300
        remoteConfig.configSettings = settings
        latestVersion = remoteConfig["latest_version_iOS"].stringValue
        currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    func checkForUpdateAndProceed(completion: @escaping (Bool) -> Void) {
        remoteConfig.fetchAndActivate { [weak self] status, error in
            guard error == nil,
                  let self = self,
                  let latestVersion,
                  let currentVersion else {
                completion(true)
                return
            }
            
            switch compareVersion(currentVersion, latestVersion) {
            case .force:
                DispatchQueue.main.async {
                    self.showForceUpdateAlert(appStoreVersion: latestVersion)
                    completion(false)
                }
            case .optional:
                DispatchQueue.main.async {
                    self.showOptionalUpdateAlert(appStoreVersion: latestVersion, completion: completion)
                }
            case .none:
                completion(true)
            }
        }
    }
    
    func checkForDowntimeAndProceed(completion: @escaping (Bool) -> Void) {
        remoteConfig.fetchAndActivate { [weak self] status, error in
            guard let self = self else {
                completion(true)
                return
            }

            if let message = self.remoteConfig["downtime_message_iOS"].stringValue,
               !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                presentMaintenanceScreen(message: message)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}

private extension AppVersionManager {
    
    func compareVersion(_ current: String, _ store: String) -> UpdateType {
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
    
    /// 강제 업데이트 Alert
    func showForceUpdateAlert(appStoreVersion: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let topViewController = windowScene.windows.first?.rootViewController else { return }
        
        let alert = UIAlertController(
            title: .AppVersion.forceTitle,
            message: .AppVersion.forceMessage(appStoreVersion),
            preferredStyle: .alert
        )
        
        let updateAction = UIAlertAction(title: .AppVersion.update, style: .default) { _ in
            self.openAppStore()
        }
        
        let exitAction = UIAlertAction(title: .AppVersion.exit, style: .destructive) { _ in
            exit(0)
        }
        
        alert.addAction(updateAction)
        alert.addAction(exitAction)
        
        topViewController.present(alert, animated: true, completion: nil)
    }
    
    /// 선택 업데이트 Alert
    func showOptionalUpdateAlert(appStoreVersion: String, completion: @escaping (Bool) -> Void) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let topViewController = windowScene.windows.first?.rootViewController else { return }
        
        let alert = UIAlertController(title: .AppVersion.optionalTitle,
                                      message: .AppVersion.optionalMessage(appStoreVersion),
                                      preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: .AppVersion.update, style: .default) { _ in
            self.openAppStore()
            completion(false) // 업데이트를 선택한 경우 스플래시에서 중지
        }
        
        let cancelAction = UIAlertAction(title: .AppVersion.later, style: .cancel) { _ in
            completion(true) // 나중에를 선택한 경우
        }
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        
        topViewController.present(alert, animated: true, completion: nil)
    }
    
    /// 업데이트를 위해 앱스토어로 이동
    func openAppStore() {
        if let url = URL(string: I18N.Common.appLink) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    /// 시스템 점검 모달창
    func presentMaintenanceScreen(message: String) {
        let viewController = MaintenanceViewController()
        viewController.configureContent(time: message)
        viewController.modalPresentationStyle = .overFullScreen

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let top = windowScene.windows.first?.rootViewController else { return }

        top.present(viewController, animated: false)
    }
}
