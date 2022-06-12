import Foundation

/// Search history persistent storage manager
final class SearchHistoryRecorder: SearchHistoryRecording {
    var history: [SearchHistoryRecord] { cache.values.map { $0 } }
    
    private typealias History = Dictionary<String, SearchHistoryRecord>
    
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    
    private lazy var fileManager = FileManager.default
    private lazy var applicationSupportUrl: URL? = try? fileManager.url(
        for: .applicationSupportDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
    )
    
    private lazy var storageUrl: URL? = applicationSupportUrl?.appendingPathComponent("history.txt")
    
    private lazy var cache: History = {
        guard
            let storageUrl = storageUrl,
            let data = try? Data(contentsOf: storageUrl),
            let result = try? decoder.decode(History.self, from: data)
        else {
            return .init()
        }
        
        return result
    }()
    
    func addRecord(_ record: SearchHistoryRecord) {
        guard
            cache[record.query] == nil,
            let storageUrl = storageUrl
        else {
            return
        }
        
        do {
            cache[record.query] = record
            let data = try encoder.encode(cache)
            try data.write(to: storageUrl, options: .atomic)
        } catch {
            cache[record.query] = nil
        }
    }
    
    func removeRecord(_ record: SearchHistoryRecord) {
        guard
            let record = cache[record.query],
            let storageUrl = storageUrl
        else {
            return
        }
        
        do {
            cache[record.query] = nil
            let data = try encoder.encode(cache)
            try data.write(to: storageUrl, options: .atomic)
        } catch {
            cache[record.query] = record
        }
    }
}
