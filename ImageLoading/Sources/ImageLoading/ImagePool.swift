import UIKit

/// Restricted-size image cache
public final class ImagePool: ImageCaching {
    private final class Key {
        let key: URL
        var next: Key?
        
        init(key: URL) {
            self.key = key
        }
    }
    
    private var firstKey: Key?
    private var lastKey: Key?
    private var storage: [URL: UIImage] = [:]
    
    private let isolationQueue = DispatchQueue(
        label: "com.dmitryvolosach.imagepool.isolation",
        attributes: .concurrent
    )
    
    private let limit: UInt
    
    /// Storage size limit
    public init(limit: UInt) {
        self.limit = limit
    }
    
    public func storeImage(_ image: UIImage, byUrl url: URL) {
        isolationQueue.async(flags: .barrier) { [weak self] in
            guard
                let self = self,
                self.storage[url] == nil
            else {
                return
            }

            if self.limit <= self.storage.count {
                self.popFirst()
            }

            self.push(image, url)
        }
    }
    
    public func image(forUrl url: URL) -> UIImage? {
        var result: UIImage?

        isolationQueue.sync {
            result = storage[url]
        }

        return result
    }
    
    private func popFirst() {
        guard let firstKey = firstKey else { return }
        
        storage[firstKey.key] = nil
        
        let secondKey = firstKey.next
        self.firstKey = secondKey
    }
    
    private func push(_ image: UIImage, _ url: URL) {
        let newKey = Key(key: url)
        
        if let lastKey = lastKey {
            lastKey.next = newKey
            self.lastKey = newKey
        } else {
            firstKey = newKey
            lastKey = newKey
        }
        
        storage[url] = image
    }
}
