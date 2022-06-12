import XCTest
@testable import flickrgram

/// Search result presenter model tests
final class SearchResultModelTests: XCTestCase {
    private var subject: SearchResultModel!
    private var imageLoader: ImageLoadingMock!
    private var presenter: SearchResultPresentableMock!
    private let loadingTitle: String = "loadingTitle"
    private let failureTitle: String = "failureTitle"
    
    override func setUpWithError() throws {
        imageLoader = .init()
        presenter = .init()
        subject = .init(
            imageLoader: imageLoader,
            loadingTitle: loadingTitle,
            failureTitle: failureTitle
        )
    }

    override func tearDownWithError() throws {
        subject = nil
        imageLoader = nil
        presenter = nil
    }
    
    func testBinding() throws {
        // when model gets bind to presenter
        subject.bind(to: presenter)
        
        // then it should
        // 1. cancel image loading
        XCTAssert(imageLoader.cancelLoadingCallsCount == 1)
        // 2. set up the presenter
        XCTAssert(presenter.setTitleCallsCount == 1)
        XCTAssert(presenter.setTitleReceivedTitle == loadingTitle)
        // 3. start loading the image
        XCTAssert(imageLoader.loadImageOnSuccessOnFailureCallsCount == 1)
    }
    
    func testUnbinding() throws {
        // when model gets unbind
        subject.unbind()
        
        // then it should cancel image loading
        XCTAssert(imageLoader.cancelLoadingCallsCount == 1)
    }
    
    func testSuccessfulLoad() throws {
        // given
        guard
            let image = UIImage(named: "back_button")
        else {
            XCTFail()
            return
        }
        
        let expectation = expectation(description: "model did fill presenter with image")
        
        presenter.setImageClosure = {
            if image == $0 {
                expectation.fulfill()
            }
        }
        subject.bind(to: presenter)
        
        // when image loaded successfully
        imageLoader.loadImageOnSuccessOnFailureReceivedArguments?.onSuccess(image)
        
        // then it should update the presenter
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFailedLoad() throws {
        // given
        let expectation = expectation(description: "model did fill presenter with title")
        
        subject.bind(to: presenter)
        presenter.setTitleClosure = { [failureTitle] in
            if $0 == failureTitle {
                expectation.fulfill()
            }
        }
        
        // when image failed to load
        imageLoader.loadImageOnSuccessOnFailureReceivedArguments?.onFailure?()
        
        // then it should update the presenter
        wait(for: [expectation], timeout: 5.0)
    }
}
