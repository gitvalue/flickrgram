import UIKit

/// Search results module navigation manager
final class SearchResultsRouter: SearchResultsRouting {
    private weak var rootViewController: UINavigationController?
    
    /// Designated initializer
    /// - Parameter rootViewController: Navigation context
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func showSearch(_ onCompletion: @escaping (String) -> ()) {

    }
}
