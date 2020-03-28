import Foundation
import RealmSwift

struct Character: Decodable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: MarvelImage
    let comics: ComicList
}

class RLMCharacter: Object {
    @objc dynamic var identifier: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var characterDescription: String = ""
    @objc dynamic var thumbnail: RLMMarvelImage? = nil
    
    class func object(from character: Character) -> RLMCharacter {
        let object = RLMCharacter()
        object.identifier = character.id
        object.name = character.name
        object.thumbnail = RLMMarvelImage.object(from: character.thumbnail)
        return object
    }
}
