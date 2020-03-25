import Foundation

enum MarvelAPIConfig {
    case gateway
    
    var baseURL: URL? {
           switch self {
           case .gateway:
               return URL(string: "https://gateway.marvel.com")
           }
       }
    
    static let apiKey = "c47b18f4fcfc4773d141663bb4ae7ed5"
    // conventiently added here for test purposes, shouldn't be stored like this
    static let privateKey = "2387bbdd5b3fe866f979997c485a91a0bb8ad229"
}
