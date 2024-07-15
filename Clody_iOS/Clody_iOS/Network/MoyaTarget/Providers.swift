//
//  Providers.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation
import Moya

struct Providers {
    static let challengeProvider = NetworkProvider<ChallengeRouter>(withAuth: true)
    static let authProvider = NetworkProvider<AuthRouter>(withAuth: true)
}

extension MoyaProvider {
    convenience init(withAuth: Bool) {
        if withAuth {
            self.init(session: Session(interceptor: AuthInterceptor.shared),
                      plugins: [MoyaLoggingPlugin()])
        } else {
            self.init(plugins: [MoyaLoggingPlugin()])
        }
    }
}

