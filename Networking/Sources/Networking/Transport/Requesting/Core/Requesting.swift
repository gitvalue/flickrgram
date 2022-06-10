import Foundation

/// Remote system request sender
public protocol Requesting {
    /// Sends the request to remote system
    /// - Parameter request: Request model
    /// - Parameter completion: Request completion handler
    func make<T>(
        request: T,
        _ completion: @escaping (Result<T.Response, Error>) -> ()
    ) where T: Request
}
