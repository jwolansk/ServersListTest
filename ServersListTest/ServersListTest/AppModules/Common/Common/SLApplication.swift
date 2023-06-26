//
//  SLApplication.swift
//  Common
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Foundation

public struct SLApplication {

    public static var viewModelFactory: ViewModelFactory!

    public static var config: ApplicationConfig = {
        guard let config = defaultConfig else {
            let msg = "SLApplication: has to be initialized correctly - please call initialize(config:) method first"
            fatalError(msg)
        }
        return config
    }()

    public static func initialize(with config: ApplicationConfig, sessionManager: SessionManager, viewModelFactory: ViewModelFactory) {
        defaultConfig = config
        NetworkConfiguration.configure(apiBaseUrl: config.apiBaseUrl)
        self.sessionManager = sessionManager
        self.viewModelFactory = viewModelFactory
    }

    private static var sessionManager: SessionManager?

    private static var defaultConfig: ApplicationConfig?

}
