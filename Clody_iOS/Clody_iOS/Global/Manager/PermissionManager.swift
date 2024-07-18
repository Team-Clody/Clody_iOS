//
//  PermissionManager.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/18/24.
//

import UIKit
import UserNotifications

import Firebase

final class PermissionManager: NSObject {
    
    let userNotiCenter = UNUserNotificationCenter.current()
    static let shared = PermissionManager()
    
    // 권한이 있는지 체크하는 함수
    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        userNotiCenter.getNotificationSettings { settings in
            completion(settings.authorizationStatus == .authorized)
        }
    }

    // 권한을 요청하는 함수
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        userNotiCenter.requestAuthorization(options: authOptions) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}


