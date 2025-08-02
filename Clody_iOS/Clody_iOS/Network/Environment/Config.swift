//
//  Config.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
            static let kakaoKey = "KAKAO_KEY"
            static let amplitudeKey = "AMPLITUDE_KEY"
            static let adUnitId = "AD_UNIT_ID"
            static let airbridgeToken = "AIRBRIDGE_TOKEN"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found.")
        }
        return dict
    }()
    
    static let baseURL: String = {
        guard let key = Config.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("Base URL is not set in plist for this configuration.")
        }
        return key
    }()
    
    static let kakaoKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.kakaoKey] as? String else {
            fatalError("Kakao Key is not set in plist for this configuration.")
        }
        return key
    }()
    
    static let amplitudeKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.amplitudeKey] as? String else {
            fatalError("Amplitude Key is not set in plist for this configuration.")
        }
        return key
    }()
    
    static let adUnitId: String = {
        guard let id = Config.infoDictionary[Keys.Plist.adUnitId] as? String else {
            fatalError("Ad Unit Id is not set in plist for this configuration.")
        }
        return id
    }()
    
    static let airbridgeToken: String = {
        guard let token = Config.infoDictionary[Keys.Plist.airbridgeToken] as? String else {
            fatalError("airbridgeToken is not set in plist for this configuration.")
        }
        return token
    }()
}
