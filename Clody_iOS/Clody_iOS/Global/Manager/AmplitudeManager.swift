//
//  AmplitudeManager.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 2/23/25.
//

import Foundation
import AmplitudeSwift

final class AmplitudeManager {
    
    static let shared = AmplitudeManager()
    
    private let amplitude: Amplitude
    
    private init() {
        let configuration = Configuration(
            apiKey: Config.amplitudeKey,
            autocapture: [.sessions, .appLifecycles, .screenViews]
        )
        self.amplitude = Amplitude(configuration: configuration)
    }
    
    func trackEvent(_ event: String, properties: [String: Any]? = nil) {
        amplitude.track(eventType: event, eventProperties: properties ?? [:])
    }
}
