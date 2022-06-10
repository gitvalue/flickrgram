import Foundation

/// Request to the remote system
public protocol Request {
    /// Type of the response of the request
    associatedtype Response: Decodable
    
    /// Request body model type
    associatedtype Body: Encodable
    
    /// Name of the request, e.g. relative path
    var name: String { get }
    
    /// Body of the request
    var body: Body { get }
}
