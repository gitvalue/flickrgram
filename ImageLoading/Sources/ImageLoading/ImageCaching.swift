import UIKit

/// Image caching service interface
public protocol ImageCaching: AnyObject {
    /// Stores an image by url key
    /// - Parameter image: Image to store
    /// - Parameter url: URL key
    func storeImage(_ image: UIImage, byUrl url: URL)
    
    /// Gets an image from storage
    /// - Parameter url: URL key
    func image(forUrl url: URL) -> UIImage?
}
