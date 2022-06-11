import Networking

/// Flickr API image search request model
struct FlickrSearchRequest: Request {
    struct Response: Decodable {
        struct Photo: Decodable {
            let id: String
            let owner: String
            let secret: String
            let server: String
            let farm: Int
            let title: String
            let isPublic: Int
            let isFriend: Int
            let isFamily: Int
        }
        
        struct Photos: Decodable {
            let page: Int
            let pages: Int
            let perPage: Int
            let total: Int
            let photo: [Photo]
        }
        
        let photos: Photos
    }
    
    struct Body: Encodable {
        let method: String = "flickr.photos.search"
        let apiKey: String = "3b1200b8ece267948c58ce549f76ad5f"
        let format: String = "json"
        let noJsonCallback: Bool = true
        let text: String
        let perPage: Int
        let page: Int
    }
    
    let name: String = "services/rest"
    let body: Body
}

// MARK: - CodingKeys

extension FlickrSearchRequest.Body {
    private enum CodingKeys: String, CodingKey {
        case method = "method"
        case apiKey = "api_key"
        case text = "text"
        case format = "format"
        case noJsonCallback = "nojsoncallback"
        case perPage = "per_page"
        case page = "page"
    }
}

extension FlickrSearchRequest.Response.Photo {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case owner = "owner"
        case secret = "secret"
        case server = "server"
        case farm = "farm"
        case title = "title"
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }
}

extension FlickrSearchRequest.Response.Photos {
    private enum CodingKeys: String, CodingKey {
        case page = "page"
        case pages = "pages"
        case perPage = "perpage"
        case total = "total"
        case photo = "photo"
    }
}
