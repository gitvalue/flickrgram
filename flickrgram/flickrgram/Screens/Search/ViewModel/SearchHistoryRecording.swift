import Foundation

/// Past search queries recording service interface
/// sourcery: AutoMockable
protocol SearchHistoryRecording: AnyObject {
    /// List of current history records
    var history: [SearchHistoryRecord] { get }
    
    /// Adds record to history
    /// - Parameter record: History record model
    func addRecord(_ record: SearchHistoryRecord)
}
