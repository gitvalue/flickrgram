import XCTest
@testable import flickrgram

/// Search queries screen viewmodel test cases
final class SearchViewModelTests: XCTestCase {
    private var subject: SearchViewModel!
    private var recorder: SearchHistoryRecordingMock!
    private var router: SearchRoutingMock!
    private var onCompletion: ((String) -> ())?
    
    override func setUpWithError() throws {
        recorder = .init()
        router = .init()
        subject = .init(recorder: recorder, router: router) { [weak self] query in
            self?.onCompletion?(query)
        }
    }

    override func tearDownWithError() throws {
        subject = nil
        recorder = nil
        router = nil
        onCompletion = nil
    }
    
    func testPlaceholder() throws {
        XCTAssert(subject.searchBarPlaceholder == "Search")
    }
    
    func testPopBack() throws {
        // when user presses the back button
        subject.onBackButtonPress()
        
        // then it should close the module
        XCTAssert(router.closeCallsCount == 1)
    }
    
    func testHistoryEntrySelection() throws {
        // given
        var query: String!
        
        onCompletion = {
            query = $0
        }
        
        recorder.history = [
            .init(query: "abc", date: .init(timeIntervalSince1970: 0)),
            .init(query: "def", date: .init(timeIntervalSince1970: 1)),
            .init(query: "ghi", date: .init(timeIntervalSince1970: 2))
        ]
        
        let selectedQueryIndex = Int.random(in: 0..<recorder.history.count)
        let selectedQueryIndexReversed = recorder.history.count - 1 - selectedQueryIndex
        
        // when user selects the query from history
        subject.onCellPress(selectedQueryIndexReversed)
        
        // then it should
        // 1. close the module
        XCTAssert(router.closeCallsCount == 1)
        // 2. notify the receiver
        XCTAssert(query == recorder.history[selectedQueryIndex].query)
    }
    
    func testSearchQueryEnter() throws {
        // given
        var resultQuery: String!
        
        onCompletion = {
            resultQuery = $0
        }
        
        let query = "query"
        
        // when user presses the 'search' button on keyboard
        subject.onSearchButtonPress(query)
        
        // then it should
        // 1. store the query
        XCTAssert(recorder.addRecordCallsCount == 1)
        XCTAssert(recorder.addRecordReceivedRecord?.query == query)
        // 2. close the module
        XCTAssert(router.closeCallsCount == 1)
        // 3. notify the receiver
        XCTAssert(resultQuery == query)
    }
}
