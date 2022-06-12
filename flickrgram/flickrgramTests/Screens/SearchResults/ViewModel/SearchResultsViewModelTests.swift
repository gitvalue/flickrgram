import XCTest
@testable import flickrgram

/// Search results screen tests
final class SearchResultsViewModelTests: XCTestCase {
    final class TestError: Error {}
    
    private var subject: SearchResultsViewModel!
    private var service: SearchResultsRequestingMock!
    private var router: SearchResultsRoutingMock!
    
    override func setUpWithError() throws {
        service = .init()
        router = .init()
        subject = .init(service: service, router: router)
    }
    
    override func tearDownWithError() throws {
        subject = nil
        service = nil
        router = nil
    }
    
    func testInitialState() throws {
        XCTAssert(subject.columnsCount == 2)
        XCTAssert(subject.searchBarPlaceholder == "Search")
        XCTAssert(subject.placeholderTitle == "No results")
        XCTAssertFalse(subject.isActivityIndicatorAnimating)
        XCTAssert(subject.query.isEmpty)
        XCTAssertFalse(subject.isPlaceholderHidden)
    }
    
    func testSearchQueryEnter() throws {
        // given
        let query = "query"
        router.showSearchClosure = { completion in
            completion(query)
        }
        
        let expectation = expectation(description: "service should load data")
        var then: (() -> ())?
        service.getImagesOfMaxCountForPageQueryClosure = { _, _, _, _ in
            expectation.fulfill()
            then?()
        }
        
        // when user typed query into search bar
        subject.onSearchBarPress()
        
        wait(for: [expectation], timeout: 5.0)
        
        // then it should request the first page
        then = { [weak service, weak subject] in
            XCTAssert(service?.getImagesOfMaxCountForPageQueryCallsCount == 2)
            XCTAssert(service?.getImagesOfMaxCountForPageQueryReceivedArguments?.query == query)
            XCTAssert(service?.getImagesOfMaxCountForPageQueryReceivedArguments?.page == 1)
            XCTAssert(service?.getImagesOfMaxCountForPageQueryReceivedArguments?.maxCount == 10)
            XCTAssert(subject?.isActivityIndicatorAnimating == true)
        }
    }
    
    func testEmptyQueryRefresh() throws {
        // given
        var deactivated: Bool!
        subject.onPullToRefreshDeactivation = {
            deactivated = true
        }
        
        // when user tries to refresh a screen with no query
        subject.onPullToRefresh()
        
        // it should immediately deactivate the refresh control
        XCTAssertTrue(deactivated)
    }
    
    func testNavigation() {
        // given
        var deactivated: Bool!
        subject.onPullToRefreshDeactivation = {
            deactivated = true
        }
        
        // when user taps the search bar
        subject.onSearchBarPress()
        
        // it should
        // 1. Hide activity indicator
        XCTAssertFalse(subject.isActivityIndicatorAnimating)
        // 2. Deactivate the refresh control
        XCTAssertTrue(deactivated)
        // 3. Open the search screen
        XCTAssert(router.showSearchCallsCount == 1)
    }
    
    func testCellReload() {
        // given
        var indexPath: IndexPath!
        subject.onCellReload = {
            indexPath = $0
        }
        
        let selectedCellIndexPath = IndexPath(row: .random(in: 0..<100), section: .random(in: 0..<100))
        
        // when user taps on the cell
        subject.onCellSelection(atIndexPath: selectedCellIndexPath)
        
        // then it should reload cell
        XCTAssert(indexPath == selectedCellIndexPath)
    }
    
    func testReload() {
        // given
        let query = "query"
        router.showSearchClosure = { completion in
            completion(query)
        }
        
        let searchResults: [String] = ["abc", "def", "ghi"]
        service.getImagesOfMaxCountForPageQueryClosure = { _, _, _, completion in
            completion(.success(searchResults))
        }
        
        let expectation = expectation(description: "view should reload")
        var then: (() -> ())?
        subject.onReload = {
            expectation.fulfill()
            then?()
        }
        
        // when user typed query into search bar
        subject.onSearchBarPress()
        
        wait(for: [expectation], timeout: 5.0)
        
        // then it should request the first page
        then = { [weak subject] in
            XCTAssert(subject?.searchResults.count == searchResults.count)
            XCTAssert(subject?.isActivityIndicatorAnimating == false)
        }
    }
    
    func testPageLoad() {
        // given
        let query = "query"
        router.showSearchClosure = { completion in
            completion(query)
        }
        
        let searchResults: [String] = ["abc", "def", "ghi"]
        service.getImagesOfMaxCountForPageQueryClosure = { _, _, _, completion in
            completion(.success(searchResults))
        }
        
        subject.onReload = { [weak subject] in
            subject?.onBottomDragging()
        }
        
        let expectation = expectation(description: "view should load second page")
        var insertedSections: IndexSet!
        var then: (() -> ())?
        subject.onSectionsInsertion = {
            insertedSections = $0
            expectation.fulfill()
            then?()
        }
        
        // when user typed query into search bar
        subject.onSearchBarPress()
        
        wait(for: [expectation], timeout: 5.0)
        
        // then it should request the second page
        then = { [weak subject] in
            XCTAssert(subject?.searchResults.count == searchResults.count * 2)
            XCTAssert(insertedSections == .init(integersIn: searchResults.count..<searchResults.count * 2))
            XCTAssert(subject?.isActivityIndicatorAnimating == false)
        }
    }
    
    func testPlaceholderVisibility() {
        // given
        let query = "query"
        router.showSearchClosure = { completion in
            completion(query)
        }
        
        let expectation = expectation(description: "service should fail")
        var then: (() -> ())?
        service.getImagesOfMaxCountForPageQueryClosure = { _, _, _, completion in
            completion(.failure(TestError()))
            expectation.fulfill()
            then?()
        }
        
        // when user typed query into search bar
        subject.onSearchBarPress()
        
        wait(for: [expectation], timeout: 5.0)
        
        // then it show the placeholder
        then = { [weak subject] in
            XCTAssert(subject?.isPlaceholderHidden == false)
        }
    }
}
