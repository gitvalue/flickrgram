import Networking

/// Flickr images service
final class SearchResultsService: SearchResultsRequesting {
    private let apiUrl: String = "https://www.flickr.com"
    private let requester: Requesting
    
    /// Designated initializer
    /// - Parameter requester: Lazy requester initializer
    init(requester: (String) -> (Requesting)) {
        self.requester = requester(apiUrl)
    }
    
    func getImages(
        ofMaxCount maxCount: Int,
        forPage page: Int,
        query: String,
        _ completion: @escaping (Result<[String], Error>) -> ()
    ) {
        let request = FlickrSearchRequest(
            body: .init(
                text: query,
                perPage: maxCount,
                page: page
            )
        )
        
        requester.make(request: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let urls = response.photos.photo.map { self.imageUrl(fromPhoto: $0) }
                completion(.success(urls))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func imageUrl(fromPhoto photo: FlickrSearchRequest.Response.Photo) -> String {
        return "https://live.staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_m.jpg"
    }
}
