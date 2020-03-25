import Foundation

protocol MarvelAPICredentialsProtocol {
    func buildQuery() -> [String: String]
}

struct MarvelAPICredentials: MarvelAPICredentialsProtocol {
    let timestamp: () -> String
    let apiKey: String
    let privateKey: String
    
    func buildQuery() -> [String: String] {
        let timestamp = self.timestamp()
        if let hash = "\(timestamp)\(privateKey)\(apiKey)".toMD5() {
            return [
                "ts": timestamp,
                "apikey": self.apiKey,
                "hash": hash
            ]
        }
        return [:]
    }
    
}
