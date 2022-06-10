import Foundation

/// Transforms arbitrary value to url parameters list format
final class URLEncoder: Encoding {
    func encode<T>(_ value: T) throws -> Data where T : Encodable {
        let data = try JSONEncoder().encode(value)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        let string = dictionary?.reduce("", { result, value in
            return result + (result.isEmpty ? "" : "&") + "\(value.key)=\(value.value)"
        })
        
        return string?.data(using: .utf8) ?? Data()
    }
}
