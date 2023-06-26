//
//  CodableStorage.swift
//  Common
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Foundation

public struct CodableStorage {

    public static func store(_ object: Codable, filename: String) throws {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(filename)

            let encoder = JSONEncoder()
            let encoded = try encoder.encode(object)
            try encoded.write(to: fileURL)
        }
    }

    public static func read<T: Codable>(filename: String) throws -> T? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(filename)

            let data = try Data(contentsOf: fileURL)

            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }
        return nil
    }
}
