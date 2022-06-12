import Foundation

/// Search history record model
struct SearchHistoryRecord: Codable {
    /// Search query
    let query: String
    
    /// Record creation date
    let date: Date
    
    init(
        query: String,
        date: Date = .init()
    ) {
        self.query = query
        self.date = date
    }
}
