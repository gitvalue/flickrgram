import Foundation

/// Search results module navigation manager interface
/// sourcery: AutoMockable
protocol SearchResultsRouting: AnyObject {
    /// Opens search query module
    /// - Parameter onCompletion: Search query input event completion handler
    func showSearch(_ onCompletion: @escaping (String) -> ())
}
