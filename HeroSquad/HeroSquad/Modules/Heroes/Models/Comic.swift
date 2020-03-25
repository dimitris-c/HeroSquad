import Foundation

struct ComicList: Decodable {
    let avalaible: Int
    let returned: Int
    let collectionURI: String
    let items: [ComicSummary]
}

struct ComicSummary: Decodable {
    let resourceURI: String
    let name: String
    
    var resourceURL: URL? {
        return URL(string: resourceURI)
    }
    
    var resourcePath: String? {
        return resourceURL?.path
    }
}
