import Foundation
import RealmSwift

struct ComicList: Decodable {
    let available: Int
    let returned: Int
    let collectionURI: String
    let items: [ComicSummary]
    
    static let empty: ComicList = ComicList(available: 0, returned: 0, collectionURI: "", items: [])
    
    static func object(from realmObject: RLMComicList) -> ComicList {
        return ComicList(available: realmObject.available,
                         returned: realmObject.returned,
                         collectionURI: realmObject.collectionURI,
                         items: realmObject.items.map(ComicSummary.object(from:)))
        
    }
}

class RLMComicList: Object {
    @objc dynamic var available: Int = 0
    @objc dynamic var returned: Int = 0
    @objc dynamic var collectionURI: String = ""
    let items = List<RLMComicSummary>()
    
    class func object(from comicList: ComicList) -> RLMComicList {
        let object = RLMComicList()
        object.available = comicList.available
        object.returned = comicList.returned
        object.collectionURI = comicList.collectionURI
        object.items.append(objectsIn: comicList.items.map(RLMComicSummary.object(from:)))
        return object
    }
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
    
    static func object(from realmObject: RLMComicSummary) -> ComicSummary {
        return ComicSummary(resourceURI: realmObject.resourseURI, name: realmObject.name)
    }
}

class RLMComicSummary: Object {
    @objc dynamic var resourseURI: String = ""
    @objc dynamic var name: String = ""
    
    class func object(from comicSummary: ComicSummary) -> RLMComicSummary {
        let object = RLMComicSummary()
        object.resourseURI = comicSummary.resourceURI
        object.name = comicSummary.name
        return object
    }
}

struct Comic: Decodable {
    let title: String
    let id: Int
    let thumbnail: MarvelImage
}
