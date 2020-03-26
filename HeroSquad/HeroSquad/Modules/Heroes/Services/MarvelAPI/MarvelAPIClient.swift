import Foundation
import RxSwift

protocol MarvelAPI {
    func getCharacters(limit: Int, offset: Int) -> Single<DataWrapper<Character>>
}

final class MarvelAPIClient: MarvelAPI {
    
    private let networking: Networking
    private let credentials: MarvelAPICredentials
    private let baseURL: URL
    
    init(networking: Networking, credentials: MarvelAPICredentials, baseURL: URL) {
        self.networking = networking
        self.credentials = credentials
        self.baseURL = baseURL
    }
    
    func getCharacters(limit: Int, offset: Int) -> Single<DataWrapper<Character>> {
        var queries = credentials.buildQuery()
        queries["limit"] = String(limit)
        queries["offset"] = String(offset)
        let endpoint = Endpoint<DataWrapper<Character>>(path: "/v1/public/characters", queries: queries)
        return self.networking.request(endpoint, baseURL: self.baseURL)
            .map { return $0.result }
    }
    
}
