//
//  UserManager.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import Foundation
import KeychainAccess

final class UserManager {
    static let shared = UserManager()
    
    private let keychain = Keychain(service: .Common.bundleID)

    private init() {}
    
    var accessToken: String? {
        get { return keychain["accessToken"] }
        set { keychain["accessToken"] = newValue }
    }
    
    var refreshToken: String? {
        get { return keychain["refreshToken"] }
        set { keychain["refreshToken"] = newValue }
    }
    
    var idToken: String? {
        get { return keychain["idToken"] }
        set { keychain["idToken"] = newValue }
    }
    
    var platform: String? {
        get { return keychain["platform"] }
        set { keychain["platform"] = newValue }
    }
    
    var fcmToken: String? {
        get { return keychain["fcmToken"] }
        set { keychain["fcmToken"] = newValue }
    }
    
    var appleEmail: String? {
        get { return keychain["appleEmail"] }
        set { keychain["appleEmail"] = newValue }
    }
    
    var hasViewedDraftAlarmBottomSheet: Bool {
        get { UserDefaults.standard.bool(forKey: "hasViewedDraftAlarmBottomSheet") }
        set { UserDefaults.standard.set(newValue, forKey: "hasViewedDraftAlarmBottomSheet") }
    }
    
    var isAutoLoginEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "isAutoLoginEnabled") && hasAccessToken }
        set { UserDefaults.standard.set(newValue, forKey: "isAutoLoginEnabled") }
    }
    
    private var hasAccessToken: Bool { return self.accessToken != nil }
    var accessTokenValue: String { return self.accessToken ?? "" }
    var refreshTokenValue: String { return self.refreshToken ?? "" }
    var idTokenValue: String { return self.idToken ?? "" }
    var platformValue: String { return self.platform ?? "" }
    var fcmTokenValue: String { return self.fcmToken ?? "" }
    var appleEmailValue: String { return self.appleEmail ?? "" }
}

extension UserManager {
    
    func updateToken(_ accessToken: String, _ refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        isAutoLoginEnabled = true
    }
    
    func updateFcmToken(_ fcmToken: String) {
        self.fcmToken = fcmToken
    }
    
    func clearAll() {
        accessToken = nil
        refreshToken = nil
        idToken = nil
        platform = nil
        isAutoLoginEnabled = false
    }
}
