//
//  SLApplication.swift
//  Common
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Foundation

public struct SLApplication {

    public static var viewModelFactory: ViewModelFactory!
    public static var sessionManager: SessionManager!
    public static var serversDataManager: DataProvider!

    public static var config: ApplicationConfig = {
        guard let config = defaultConfig else {
            let msg = "SLApplication: has to be initialized correctly - please call initialize(config:) method first"
            fatalError(msg)
        }
        return config
    }()

    public static func initialize(with config: ApplicationConfig,
                                  sessionManager: SessionManager,
                                  serversDataManager: DataProvider,
                                  viewModelFactory: ViewModelFactory) {
        defaultConfig = config
        NetworkConfiguration.configure(apiBaseUrl: config.apiBaseUrl)
        self.sessionManager = sessionManager
        self.serversDataManager = serversDataManager
        self.viewModelFactory = viewModelFactory
    }


    private static var defaultConfig: ApplicationConfig?

}
