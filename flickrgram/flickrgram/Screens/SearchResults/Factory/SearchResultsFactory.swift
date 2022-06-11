import Networking
import UIKit

/// Search results module creation factory
final class SearchResultsFactory {
    /// Creates image search results module
    /// - Parameter navigationController: Navigation context
    func create(withNavigationController navigationController: UINavigationController) -> UIViewController {
        let router = SearchResultsRouter(rootViewController: navigationController)
        let service = SearchResultsService(requester: { UrlRestApiRequester(apiUrl: $0) })
        let viewModel = SearchResultsViewModel(service: service, router: router)
        
        return SearchResultsViewController(viewModel: viewModel)
    }
}
