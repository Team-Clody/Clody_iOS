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
            fatalError("Base URL is not set in plist for this configuration.")
        }
        return key
    }()

}
