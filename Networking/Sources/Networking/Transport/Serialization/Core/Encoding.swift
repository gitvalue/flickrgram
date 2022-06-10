import Foundation

/// Arbitrary value to `Data` encoder interface
protocol Encoding: AnyObject {
    /// Encodes the given top-level value and returns its JSON representation.
    ///
    /// - Parameter value: The value to encode.
    /// - Returns: A new `Data` value containing the encoded JSON data.
    /// - Throws:
    ///     - `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
    ///     - An error if any value throws an error during encoding.
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

