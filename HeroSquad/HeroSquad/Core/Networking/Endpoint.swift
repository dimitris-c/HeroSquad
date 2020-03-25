import Foundation

typealias Path = String
typealias Parameters = [String: String]

enum Method: String {
    case get = "GET"
    case post = "POST"
}

final class Endpoint<Response: Decodable> {
    let method: Method
    let path: Path
    let queries: Codable?
    let parameters: Parameters?
    let decode: (Data) throws -> Response
    let cachePolicy: URLRequest.CachePolicy
    
    init(method: Method,
         path: Path,
         parameters: Parameters?,
         queries: Codable? = nil,
         decode: @escaping (Data) throws -> Response,
         cachePolicy: URLRequest.CachePolicy) {
        self.method = method
        self.path = path
        self.queries = queries
        self.parameters = parameters
        self.decode = decode
        self.cachePolicy = cachePolicy
    }
 
    public convenience init(method: Method = .get,
                            path: Path,
                            parameters: Parameters? = nil,
                            queries: Codable? = nil,
                            cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData) {
        self.init(method: method,
                  path: path,
                  parameters: parameters,
                  queries: queries,
                  decode: { data in try JSONDecoder().decode(Response.self, from: data) },
                  cachePolicy: cachePolicy
        )
    }
}
