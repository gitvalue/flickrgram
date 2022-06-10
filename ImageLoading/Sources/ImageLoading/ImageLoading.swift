import UIKit

/// Asynchronous image loading service interface
/// sourcery: AutoMockable
public protocol ImageLoading: AnyObject {
    /// Asynchronously loads an image
    /// - Parameter onSuccess: Load success event handler
    /// - Parameter onFailure: Load failure event handler
    func loadImage(
        onSuccess: @escaping (UIImage) -> (),
        onFailure: (() -> ())?
    )
    
    /// Cancels image loading, if active
    func cancelLoading()
}
