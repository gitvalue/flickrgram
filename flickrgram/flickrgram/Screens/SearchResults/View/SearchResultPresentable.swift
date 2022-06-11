import UIKit

/// Interface of the view presenting the search result
/// sourcery: AutoMockable
protocol SearchResultPresentable: AnyObject {
    /// Assings the tiltle label text
    /// - Parameter title: Title label text
    func setTitle(_ title: String)
    
    /// Assigns the search result image
    /// - Parameter image: Search result image
    func setImage(_ image: UIImage)    
}
