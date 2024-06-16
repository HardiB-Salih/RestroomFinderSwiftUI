//
//  JSONHelper.swift
//  Created by HardiB.Salih on 6/15/24.
//

import Foundation


struct JSONHelper {
    /// Loads and parses a JSON file from the main bundle into the specified Codable type.
    ///
    /// Example:
    /// ```swift
    /// let movieResponse: MovieResponse = JSONHelper.load("movie.json")
    /// ```
    ///
    /// - Parameter filename: The name of the JSON file (with file extension) to load.
    /// - Returns: The decoded object of type `T`.
    static func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}

