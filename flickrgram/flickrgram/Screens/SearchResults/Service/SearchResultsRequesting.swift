import Foundation

/// Search results service interface
/// sourcery: AutoMockable
protocol SearchResultsRequesting: AnyObject {
    /// Requests bunch of images
    /// - Parameter maxCount: Page size
    /// - Parameter page: Page index
    /// - Parameter query: Search query
    /// - Parameter completion: Request completion handler. Returns the images URLs list
    func getImages(
        ofMaxCount maxCount: Int,
        forPage page: Int,
        query: String,
        _ completion: @escaping (Result<[String], Error>) -> ()
    )
}
