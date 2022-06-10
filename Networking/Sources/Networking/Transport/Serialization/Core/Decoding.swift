import Foundation

/// `Data` to arbitrary value decoder interface
protocol Decoding: AnyObject {
    /// Decodes a top-level value of the given type from the given JSON representation
    ///
    /// - Parameters:
    ///   - type: The type of the value to decode
    ///   - data: The data to decode from
    /// - Returns: A value of the requested type
    /// - Throws:
    ///     - `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON
    ///     - An error if any value throws an error during decoding
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}
