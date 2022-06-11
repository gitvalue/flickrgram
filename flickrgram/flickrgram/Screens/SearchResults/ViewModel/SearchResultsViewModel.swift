import Foundation
import ImageLoading
import UIKit

/// Search results screen business-logic
final class SearchResultsViewModel {
    private let service: SearchResultsRequesting
    private let router: SearchResultsRouting
    
    /// Designated initializer
    /// - Parameter service: Image search service
    /// - Parameter router: Router
    init(service: SearchResultsRequesting, router: SearchResultsRouting) {
        self.service = service
        self.router = router
    }
}
