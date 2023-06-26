//
//  Server.swift
//  Servers
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Foundation

struct Server: Codable, Identifiable {
    var id: String { UUID().uuidString }

    let name: String
    let distance: Int
}
