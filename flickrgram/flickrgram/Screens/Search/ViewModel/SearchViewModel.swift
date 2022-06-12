import Foundation

/// Search queries screen viewmodel
final class SearchViewModel {
    /// Search bar placeholder text
    let searchBarPlaceholder: String = "Search"
    
    /// Past queries history
    var queries: [String] {
        recorder.history.sorted {
            $1.date < $0.date
        }.map {
            $0.query
        }
    }
    
    private let recorder: SearchHistoryRecording
    private let router: SearchRouting
    private let onCompletion: (String) -> ()
    
    /// Designated initializer
    /// - Parameter recorder: Queries history recording service
    /// - Parameter router: Navigation manager
    /// - Parameter onCompletion: Query entering completion handler
    init(
        recorder: SearchHistoryRecording,
        router: SearchRouting,
        onCompletion: @escaping (String) -> ()
    ) {
        self.recorder = recorder
        self.router = router
        self.onCompletion = onCompletion
    }
    
    /// Handles back button press event
    func onBackButtonPress() {
        router.close()
    }
    
    /// Handles queries history cell press event
    /// - Parameter index: Cell index
    func onCellPress(_ index: Int) {
        router.close()
        onCompletion(queries[index])
    }
    
    /// Handles keyboard 'search' button press event
    /// - Parameter query: Current search query
    func onSearchButtonPress(_ query: String?) {
        if let query = query, !query.isEmpty {
            recorder.addRecord(.init(query: query))
            router.close()
            onCompletion(query)
        }
    }
}
