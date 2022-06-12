import UIKit

/// Search query module factory
final class SearchFactory {
    /// Designated initializer
    /// - Parameter navigationController: Navigation context
    /// - Parameter onCompletion: Completion handler
    func create(
        withNavigationController navigationController: UINavigationController,
        onCompletion: @escaping (String) -> ()
    ) -> UIViewController {
        let queriesHistoryRecorder = SearchHistoryRecorder()
        let router = SearchRouter(rootViewController: navigationController)
        let viewModel = SearchViewModel(recorder: queriesHistoryRecorder, router: router, onCompletion: onCompletion)
        let viewController = SearchViewController(viewModel: viewModel)
        
        return viewController
    }
}
