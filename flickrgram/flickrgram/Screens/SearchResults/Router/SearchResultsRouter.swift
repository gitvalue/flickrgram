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
        guard let rootViewController = rootViewController else { return }

        let factory = SearchFactory()
        let viewController = factory.create(
            withNavigationController: rootViewController,
            onCompletion: onCompletion
        )
        rootViewController.pushViewController(viewController, animated: false)
    }
}
