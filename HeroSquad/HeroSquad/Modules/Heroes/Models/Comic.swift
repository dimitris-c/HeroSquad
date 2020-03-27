import Foundation

struct ComicList: Decodable {
    let available: Int
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

struct Comic: Decodable {
    let title: String
    let id: Int
    let thumbnail: MarvelImage
}
