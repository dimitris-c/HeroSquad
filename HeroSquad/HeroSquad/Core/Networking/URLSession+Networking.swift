import Foundation
import RxSwift
import RxCocoa

enum NetworkError: Error, Equatable {
    case unknown
    case nonHTTPResponse(response: URLResponse)
    case decodingFailed
    case httpRequestFailed(response: HTTPURLResponse, data: Data?)
}

protocol NetworkingSession {
    func response(request: URLRequest, completion: @escaping (Result<(response: HTTPURLResponse, data: Data), Error>) -> Void)
    
    func response(request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)>
}

extension URLSession: NetworkingSession {
    func response(request: URLRequest, completion: @escaping (Result<(response: HTTPURLResponse, data: Data), Error>) -> Void) {
        let task = self.dataTask(with: request) { (data, response, error) in
            guard let response = response, let data = data else {
                completion(.failure(error ?? NetworkError.unknown))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.nonHTTPResponse(response: response)))
                return
            }
            
            completion(.success((httpResponse, data)))
        }
        
        task.resume()
    }
    
    func response(request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
        return self.rx.response(request: request)
    }
}
