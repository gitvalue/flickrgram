import XCTest
@testable import flickrgram

/// Search result presenter model tests
final class SearchResultsServiceTests: XCTestCase {
    private final class TestError: LocalizedError {}
    
    private var subject: SearchResultsService!
    private var requester: RequestingMock<FlickrSearchRequest>!
    
    override func setUpWithError() throws {
        requester = .init()
        subject = .init(requester: { _ in requester })
    }

    override func tearDownWithError() throws {
        subject = nil
        requester = nil
    }
    
    func testRequestComposing() throws {
        // given
        let maxCount = Int.random(in: 0..<100)
        let page = Int.random(in: 0..<100)
        let query = "query"
        
        // when request starts
        subject.getImages(ofMaxCount: maxCount, forPage: page, query: query) { _ in }
        
        // then it should be composed correctly
        let request = requester.makeRequestReceivedArguments?.request
        XCTAssert(request?.body.text == query)
        XCTAssert(request?.body.perPage == maxCount)
        XCTAssert(request?.body.page == page)
    }
    
    func testSuccessfulLoad() throws {
        // given
        let response = FlickrSearchRequest.Response(
            photos: .init(
                page: 0,
                pages: 0,
                perPage: 0,
                total: 0,
                photo: [
                    .init(
                        id: "id",
                        owner: "",
                        secret: "secret",
                        server: "server",
                        farm: 0,
                        title: "",
                        isPublic: 0,
                        isFriend: 0,
                        isFamily: 0
                    )
                ]
            )
        )
        
        requester.makeRequestClosure = { _, completion in
            completion(.success(response))
        }
        
        var receivedModel: [String]!
        
        // when request finishes
        subject.getImages(ofMaxCount: 0, forPage: 0, query: "") { result in
            if case .success(let model) = result {
                receivedModel = model
            }
        }
        
        // then it should be correct
        XCTAssert(receivedModel == ["https://live.staticflickr.com/server/id_secret_m.jpg"])
    }
    
    func testFailedLoad() throws {
        // given
        let error = TestError()
        
        requester.makeRequestClosure = { _, completion in
            completion(.failure(error))
        }
        
        var receivedError: TestError!
        
        // when request fails
        subject.getImages(ofMaxCount: 0, forPage: 0, query: "") { result in
            if case .failure(let error) = result {
                receivedError = error as? TestError
            }
        }
        
        // then it should notify the receiver
        XCTAssert(receivedError === error)
    }
}
