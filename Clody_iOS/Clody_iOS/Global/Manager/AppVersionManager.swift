//
//  AppVersionManager.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 8/18/24.
//

import UIKit
import FirebaseRemoteConfig

class AppVersionManager {
    
    private enum UpdateType {
        case force, optional, none
    }
    
    static let shared = AppVersionManager()
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    private init() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 300
        remoteConfig.configSettings = settings
    }
    
    func checkForUpdateAndProceed(completion: @escaping (Bool) -> Void) {
        remoteConfig.fetchAndActivate { status, error in
            guard error == nil, let latestVersion = self.remoteConfig["latest_version_iOS"].stringValue else {
                completion(true)
                return
            }
            
            
            let currentVersion = self.currentAppVersion()
            
            switch self.compareVersion(currentVersion, latestVersion) {
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
            title: I18N.AppVersion.forceTitle,
            message: I18N.AppVersion.forceMessage(appStoreVersion),
            preferredStyle: .alert
        )
        
        let updateAction = UIAlertAction(title: I18N.AppVersion.update, style: .default) { _ in
            self.openAppStore()
        }
        
        let exitAction = UIAlertAction(title: I18N.AppVersion.exit, style: .destructive) { _ in
            exit(0)
        }
        
        alert.addAction(updateAction)
        alert.addAction(exitAction)
        
        topViewController.present(alert, animated: true, completion: nil)
    }
    
    private func showOptionalUpdateAlert(appStoreVersion: String, completion: @escaping (Bool) -> Void) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let topViewController = windowScene.windows.first?.rootViewController else { return }
        
        let alert = UIAlertController(title: I18N.AppVersion.optionalTitle,
                                      message: I18N.AppVersion.optionalMessage(appStoreVersion),
                                      preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: I18N.AppVersion.update, style: .default) { _ in
            self.openAppStore()
            completion(false) // 업데이트를 선택한 경우 스플래시에서 중지
        }
        
        let cancelAction = UIAlertAction(title: I18N.AppVersion.later, style: .cancel) { _ in
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

extension AppVersionManager {
    func checkForDowntimeAndProceed(completion: @escaping (Bool) -> Void) {
        remoteConfig.fetchAndActivate { [weak self] status, error in
            guard let self = self else {
                completion(true)
                return
            }

            let message = self.remoteConfig["downtime_message_iOS"].stringValue ?? "none"

            if message == "none" {
                DispatchQueue.main.async {
                    self.presentMaintenanceScreen(message: message)
                    completion(false) // 진행 중단
                }
            } else {
                completion(true) // 계속 진행
            }
        }
    }

    private func presentMaintenanceScreen(message: String) {
        
        let viewController = MaintenanceViewController()
        viewController.configureContent(time: message)
        viewController.modalPresentationStyle = .overFullScreen

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let top = windowScene.windows.first?.rootViewController else { return }

        top.present(viewController, animated: false)
    }

}
