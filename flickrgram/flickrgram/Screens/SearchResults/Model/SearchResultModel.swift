import Foundation
import ImageLoading
import UIKit

/// Search result presenter model
final class SearchResultModel {
    private weak var presenter: SearchResultPresentable?
    
    private let imageLoader: ImageLoading
    private let loadingTitle: String
    private let failureTitle: String
    
    /// Designated initializer
    /// - Parameter imageLoader: Asynchronous image loading service
    /// - Parameter loadingTitle: Loading state cell title text
    /// - Parameter failureTitle: Failed state cell title text
    init(
        imageLoader: ImageLoading,
        loadingTitle: String,
        failureTitle: String
    ) {
        self.imageLoader = imageLoader
        self.loadingTitle = loadingTitle
        self.failureTitle = failureTitle
    }
    
    /// Binds model to presenter
    /// - Parameter presenter: Presenter to be binded to
    func bind(to presenter: SearchResultPresentable) {
        unbind()
        
        self.presenter = presenter
        
        presenter.setTitle(loadingTitle)
        
        imageLoader.loadImage { [weak self] image in
            self?.onImageLoadSuccess(image)
        } onFailure: { [weak self] in
            self?.onImageLoadFailure()
        }
    }
    
    /// Unbinds model from presenter
    func unbind() {
        presenter = nil
        imageLoader.cancelLoading()
    }
    
    private func onImageLoadSuccess(_ image: UIImage) {
        DispatchQueue.main.async {
            self.presenter?.setImage(image)
        }
    }
    
    private func onImageLoadFailure() {
        DispatchQueue.main.async {
            self.presenter?.setTitle(self.failureTitle)
        }
    }
}
