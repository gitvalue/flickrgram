import UIKit

/// Displays the search results screen
final class SearchResultsViewController: UIViewController {
    private let viewModel: SearchResultsViewModel
    
    /// Designated initializer
    /// - Parameter viewModel: ViewModel
    init(viewModel: SearchResultsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
