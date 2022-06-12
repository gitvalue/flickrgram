// Generated using Sourcery 1.8.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import ImageLoading

@testable import flickrgram














class ImageLoadingMock: ImageLoading {

    //MARK: - loadImage

    var loadImageOnSuccessOnFailureCallsCount = 0
    var loadImageOnSuccessOnFailureCalled: Bool {
        return loadImageOnSuccessOnFailureCallsCount > 0
    }
    var loadImageOnSuccessOnFailureReceivedArguments: (onSuccess: (UIImage) -> (), onFailure: (() -> ())?)?
    var loadImageOnSuccessOnFailureReceivedInvocations: [(onSuccess: (UIImage) -> (), onFailure: (() -> ())?)] = []
    var loadImageOnSuccessOnFailureClosure: ((@escaping (UIImage) -> (), (() -> ())?) -> Void)?

    func loadImage(onSuccess: @escaping (UIImage) -> (), onFailure: (() -> ())?) {
        loadImageOnSuccessOnFailureCallsCount += 1
        loadImageOnSuccessOnFailureReceivedArguments = (onSuccess: onSuccess, onFailure: onFailure)
        loadImageOnSuccessOnFailureReceivedInvocations.append((onSuccess: onSuccess, onFailure: onFailure))
        loadImageOnSuccessOnFailureClosure?(onSuccess, onFailure)
    }

    //MARK: - cancelLoading

    var cancelLoadingCallsCount = 0
    var cancelLoadingCalled: Bool {
        return cancelLoadingCallsCount > 0
    }
    var cancelLoadingClosure: (() -> Void)?

    func cancelLoading() {
        cancelLoadingCallsCount += 1
        cancelLoadingClosure?()
    }

}
class SearchHistoryRecordingMock: SearchHistoryRecording {
    var history: [SearchHistoryRecord] = []

    //MARK: - addRecord

    var addRecordCallsCount = 0
    var addRecordCalled: Bool {
        return addRecordCallsCount > 0
    }
    var addRecordReceivedRecord: SearchHistoryRecord?
    var addRecordReceivedInvocations: [SearchHistoryRecord] = []
    var addRecordClosure: ((SearchHistoryRecord) -> Void)?

    func addRecord(_ record: SearchHistoryRecord) {
        addRecordCallsCount += 1
        addRecordReceivedRecord = record
        addRecordReceivedInvocations.append(record)
        addRecordClosure?(record)
    }

}
class SearchResultPresentableMock: SearchResultPresentable {

    //MARK: - setTitle

    var setTitleCallsCount = 0
    var setTitleCalled: Bool {
        return setTitleCallsCount > 0
    }
    var setTitleReceivedTitle: String?
    var setTitleReceivedInvocations: [String] = []
    var setTitleClosure: ((String) -> Void)?

    func setTitle(_ title: String) {
        setTitleCallsCount += 1
        setTitleReceivedTitle = title
        setTitleReceivedInvocations.append(title)
        setTitleClosure?(title)
    }

    //MARK: - setImage

    var setImageCallsCount = 0
    var setImageCalled: Bool {
        return setImageCallsCount > 0
    }
    var setImageReceivedImage: UIImage?
    var setImageReceivedInvocations: [UIImage] = []
    var setImageClosure: ((UIImage) -> Void)?

    func setImage(_ image: UIImage) {
        setImageCallsCount += 1
        setImageReceivedImage = image
        setImageReceivedInvocations.append(image)
        setImageClosure?(image)
    }

}
class SearchResultsRequestingMock: SearchResultsRequesting {

    //MARK: - getImages

    var getImagesOfMaxCountForPageQueryCallsCount = 0
    var getImagesOfMaxCountForPageQueryCalled: Bool {
        return getImagesOfMaxCountForPageQueryCallsCount > 0
    }
    var getImagesOfMaxCountForPageQueryReceivedArguments: (maxCount: Int, page: Int, query: String, completion: (Result<[String], Error>) -> ())?
    var getImagesOfMaxCountForPageQueryReceivedInvocations: [(maxCount: Int, page: Int, query: String, completion: (Result<[String], Error>) -> ())] = []
    var getImagesOfMaxCountForPageQueryClosure: ((Int, Int, String, @escaping (Result<[String], Error>) -> ()) -> Void)?

    func getImages(ofMaxCount maxCount: Int, forPage page: Int, query: String, _ completion: @escaping (Result<[String], Error>) -> ()) {
        getImagesOfMaxCountForPageQueryCallsCount += 1
        getImagesOfMaxCountForPageQueryReceivedArguments = (maxCount: maxCount, page: page, query: query, completion: completion)
        getImagesOfMaxCountForPageQueryReceivedInvocations.append((maxCount: maxCount, page: page, query: query, completion: completion))
        getImagesOfMaxCountForPageQueryClosure?(maxCount, page, query, completion)
    }

}
class SearchResultsRoutingMock: SearchResultsRouting {

    //MARK: - showSearch

    var showSearchCallsCount = 0
    var showSearchCalled: Bool {
        return showSearchCallsCount > 0
    }
    var showSearchReceivedOnCompletion: ((String) -> ())?
    var showSearchReceivedInvocations: [((String) -> ())] = []
    var showSearchClosure: ((@escaping (String) -> ()) -> Void)?

    func showSearch(_ onCompletion: @escaping (String) -> ()) {
        showSearchCallsCount += 1
        showSearchReceivedOnCompletion = onCompletion
        showSearchReceivedInvocations.append(onCompletion)
        showSearchClosure?(onCompletion)
    }

}
class SearchRoutingMock: SearchRouting {

    //MARK: - close

    var closeCallsCount = 0
    var closeCalled: Bool {
        return closeCallsCount > 0
    }
    var closeClosure: (() -> Void)?

    func close() {
        closeCallsCount += 1
        closeClosure?()
    }

}
