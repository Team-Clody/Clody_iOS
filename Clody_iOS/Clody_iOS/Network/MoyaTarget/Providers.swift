//
//  Providers.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/15/24.
//

import Foundation
import Moya

struct Providers {
    static let calendarProvider = NetworkProvider<CalendarRouter>(withAuth: true)
    static let authProvider = NetworkProvider<AuthRouter>(withAuth: true)
    static let myPageProvider = NetworkProvider<MyPageRouter>(withAuth: true)
    static let diaryRouter = NetworkProvider<DiaryRouter>(withAuth: true)
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

