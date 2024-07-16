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
    
    private let keychain = Keychain(service: "com.Clody.Clody")

    private init() {}
    
    var accessToken: String? {
        get { return keychain["accessToken"] }
        set { keychain["accessToken"] = newValue }
    }
    
    var refreshToken: String? {
        get { return keychain["refreshToken"] }
        set { keychain["refreshToken"] = newValue }
    }
    
    var authCode: String? {
        get { return keychain["authCode"] }
        set { keychain["authCode"] = newValue }
    }
    
    var idToken: String? {
        get { return keychain["idToken"] }
        set { keychain["idToken"] = newValue }
    }
    
    var platForm: String? {
        get { return keychain["platForm"] }
        set { keychain["platForm"] = newValue }
    }
    
    var hasAccessToken: Bool { return self.accessToken != nil }
    var accessTokenValue: String { return self.accessToken ?? "" }
    var refreshTokenValue: String { return self.refreshToken ?? "" }
    var authCodeValue: String { return self.authCode ?? "" }
    var idTokenValue: String { return self.idToken ?? "" }
    var platFormValue: String { return self.platForm ?? "" }
}

extension UserManager {
    func updateToken(_ accessToken: String, _ refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func updateAuthCode(_ authCode: String) {
        self.authCode = authCode
    }
    
    func clearAll() {
        self.accessToken = nil
        self.refreshToken = nil
        self.authCode = nil
        self.idToken = nil
        self.platForm = nil
    }
}

