import UIKit

/// Search query module navigation manager
final class SearchRouter: SearchRouting {
    private weak var rootViewController: UINavigationController?
    
    /// Designated initializer
    /// - Parameter rootViewController: Navigation context
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func close() {
        rootViewController?.popViewController(animated: false)
    }
}
