import Foundation
import ImageLoading
import UIKit

/// Search results screen business-logic
final class SearchResultsViewModel {
    /// Number of columns in each row
    let columnsCount: Int = 2
    
    /// Search bar placeholder text
    let searchBarPlaceholder: String = "Search"
    
    /// Results list placeholder title label text
    let placeholderTitle: String = "No results"
        
    /// Pull-to-refresh indicator deactivation event handler
    var onPullToRefreshDeactivation: (() -> ())?
    
    /// Full screen reload event handler
    var onReload: (() -> ())?
    
    /// New sections insertion event handler
    var onSectionsInsertion: ((IndexSet) -> ())?
    
    /// Cell at index reload event handler
    var onCellReload: ((IndexPath) -> ())?
    
    /// Activity indicator animating state
    @Observable
    private(set) var isActivityIndicatorAnimating: Bool = false
    
    /// Search query value
    @Observable
    private(set) var query: String = ""
    
    /// Results list placeholder visibility indicator
    @Observable
    private(set) var isPlaceholderHidden: Bool = false
        
    /// Search results model
    private(set) var searchResults: [SearchResultModel] = [] {
        didSet {
            isPlaceholderHidden = !searchResults.isEmpty
        }
    }
    
    private var currentPage: Int = 1
    private var pageSize: Int = 10
    
    private let imagePool = ImagePool(limit: 100)
    
    private let imageLoadingQueue: OperationQueue = {
        let result = OperationQueue()
        result.underlyingQueue = .global(qos: .default)
        result.maxConcurrentOperationCount = 20
        
        return result
    }()
    
    private let dataLoadingQueue: OperationQueue = {
        let result = OperationQueue()
        result.underlyingQueue = .global(qos: .default)
        result.maxConcurrentOperationCount = 1
        
        return result
    }()
    
    private let service: SearchResultsRequesting
    private let router: SearchResultsRouting
    
    /// Designated initializer
    /// - Parameter service: Image search service
    /// - Parameter router: Router
    init(service: SearchResultsRequesting, router: SearchResultsRouting) {
        self.service = service
        self.router = router
    }
    
    /// Handles view loading completion event
    func onViewLoad() {
        loadNextPage()
    }
    
    /// Handles user reaching the bottom of the scroll event
    func onBottomDragging() {
        loadNextPage()
    }
    
    /// Handles user using pull-to-refresh event
    func onPullToRefresh() {
        if query.isEmpty {
            onPullToRefreshDeactivation?()
        } else {
            dataLoadingQueue.cancelAllOperations()
            currentPage = 1
            loadNextPage()
        }
    }
    
    /// Handles search bar tap event
    func onSearchBarPress() {
        isActivityIndicatorAnimating = false
        onPullToRefreshDeactivation?()
        
        router.showSearch() { [weak self] query in
            guard let self = self else { return }
                        
            self.dataLoadingQueue.cancelAllOperations()
            self.query = query
            self.currentPage = 1
            self.isActivityIndicatorAnimating = true
            self.loadNextPage()
        }
    }
    
    /// Handles cell selection event
    /// - Parameter atIndexPath: Index of the touched cell
    func onCellSelection(atIndexPath indexPath: IndexPath) {
        onCellReload?(indexPath)
    }
    
    private func loadNextPage() {
        guard dataLoadingQueue.operationCount == 0, !query.isEmpty else { return }
                
        let operation = SyncOperation { [weak self] in
            return self?.getImages()
        } completion: { [weak self] result in
            guard let result = result else { return }
            self?.handleImages(result)
        }
        
        dataLoadingQueue.addOperation(operation)
    }
    
    private func getImages() -> Result<[String], Error>? {
        var result: Result<[String], Error>?
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        service.getImages(ofMaxCount: pageSize, forPage: currentPage, query: query) { res in
            result = res
            dispatchGroup.leave()
        }
        
        dispatchGroup.wait()
        
        return result
    }
    
    private func handleImages(_ result: Result<[String], Error>) {
        if case .success(let urls) = result {
            DispatchQueue.main.async {
                self.appendNewImages(urls)
            }
        } else if currentPage == 1 {
            DispatchQueue.main.async {
                self.searchResults = []
                self.onReload?()
            }
        }
    }
    
    private func appendNewImages(_ urls: [String]) {
        isActivityIndicatorAnimating = false
        onPullToRefreshDeactivation?()
        
        let newSearchResults: [SearchResultModel] = urls.compactMap {
            guard let url = URL(string: $0) else { return nil }
            
            let imageLoader = ImageLoader(queue: imageLoadingQueue, url: url, cache: imagePool)
            let model = SearchResultModel(
                imageLoader: imageLoader,
                loadingTitle: "Loading",
                failureTitle: "Failed to load image\nPress to retry"
            )
            
            return model
        }
        
        let firstNewSectionIndex = ((currentPage - 1) * pageSize) / columnsCount
        
        let newSectionsCount = newSearchResults.count % columnsCount == 0 ?
            newSearchResults.count / columnsCount :
            newSearchResults.count / columnsCount + 1
        
        let lastNewSectionIndex = firstNewSectionIndex + newSectionsCount
                
        if currentPage == 1 {
            searchResults = newSearchResults
            onReload?()
        } else {
            searchResults.append(contentsOf: newSearchResults)
            onSectionsInsertion?(.init(integersIn: firstNewSectionIndex..<lastNewSectionIndex))
        }
        
        currentPage += 1
    }
}
