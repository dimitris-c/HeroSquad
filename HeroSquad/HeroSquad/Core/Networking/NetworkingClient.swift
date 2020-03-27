import Foundation
import RxSwift
import RxCocoa

typealias NetworkCompletion<Response> = (Result<(response: HTTPURLResponse, result: Response), Error>) -> Void
protocol Networking {
    func request<Response>(_ endpoint: Endpoint<Response>, baseURL: URL, completion: @escaping NetworkCompletion<Response>)
    // MARK: Reactive
    func request<Response>(_ endpoint: Endpoint<Response>, baseURL: URL) -> Single<(response: HTTPURLResponse, result: Response)>
    func request<Response>(_ endpoint: Endpoint<Response>, baseURL: URL) -> Observable<(response: HTTPURLResponse, result: Response)>
}

final class NetworkingClient: Networking {
    
    private let session: NetworkingSession
    
    init(session: NetworkingSession = URLSession.shared, logging: Bool = false) {
        self.session = session
        Logging.URLRequests = { _ in logging }
    }
    
    func request<Response>(_ endpoint: Endpoint<Response>, baseURL: URL, completion: @escaping NetworkCompletion<Response>) {
        let request = self.buildRequest(endpoint: endpoint, baseURL: baseURL)
        
        self.session.response(request: request) { result in
            switch result {
            case .success(let value):
                if let result = try? endpoint.decode(value.data) {
                    completion(.success((value.response, result)))
                } else {
                    completion(.failure(NetworkError.decodingFailed))
                }
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
        
    }
    
    // MARK: Reactive
    
    func request<Response>(_ endpoint: Endpoint<Response>, baseURL: URL) -> Observable<(response: HTTPURLResponse, result: Response)> {
        let request = self.buildRequest(endpoint: endpoint, baseURL: baseURL)
        return self.session.response(request: request).map { (response, data) -> (HTTPURLResponse, Response) in
            let result = try endpoint.decode(data)
            return (response: response, result: result)
        }
    }
    
    func request<Response>(_ endpoint: Endpoint<Response>, baseURL: URL) -> Single<(response: HTTPURLResponse, result: Response)> {
        return self.request(endpoint, baseURL: baseURL).asSingle()
    }
    
    // MARK: Private
    
    private func buildRequest<Response>(endpoint: Endpoint<Response>, baseURL: URL) -> URLRequest {
        let url = self.url(from: endpoint.path, queries: endpoint.queries, baseURL: baseURL)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.cachePolicy = endpoint.cachePolicy
        
        if let body = endpoint.parameters {
            request.httpBody = body.toJSONData()
        }
        
        return request
    }
    
    private func url(from path: Path, queries: Codable?, baseURL: URL) -> URL {
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            return baseURL.appendingPathComponent(path)
        }
        urlComponents.path = path
        
        if let queryValues = queries?.dictionary, !queryValues.isEmpty {
            let queryItems = queryValues.map { (key, value) in
                return URLQueryItem(name: key, value: value)
            }
            urlComponents.queryItems = queryItems
        }
        return urlComponents.url ?? baseURL
    }
}
