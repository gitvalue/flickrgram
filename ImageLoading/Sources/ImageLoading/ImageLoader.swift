import UIKit

/// Remote image loader
public final class ImageLoader: ImageLoading {
    private var operation: Operation?
    
    private let queue: OperationQueue
    private let url: URL
    private let cache: ImageCaching
    
    /// Designated initializer
    /// - Parameter queue: Tasks queue
    /// - Parameter url: Image URL
    /// - Parameter cache: Images cache
    public init(
        queue: OperationQueue,
        url: URL,
        cache: ImageCaching
    ) {
        self.queue = queue
        self.url = url
        self.cache = cache
    }
    
    public func loadImage(onSuccess: @escaping (UIImage) -> (), onFailure: (() -> ())?) {
        cancelLoading()
        
        if let image = cache.image(forUrl: url) {
            onSuccess(image)
            return
        }
        
        let operation = SyncOperation { [url] in
            return try? Data(contentsOf: url)
        } completion: { [weak self] data in
            if let self = self, let data = data, let image = UIImage(data: data) {
                self.cache.storeImage(image, byUrl: self.url)
                onSuccess(image)
            } else {
                onFailure?()
            }
        }
        
        queue.addOperation(operation)
        self.operation = operation
    }
    
    public func cancelLoading() {
        if let operation = operation, operation.isExecuting {
            operation.cancel()
        }
    }
}
