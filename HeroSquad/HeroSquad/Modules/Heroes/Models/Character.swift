import Foundation
import RealmSwift

struct Character: Decodable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: MarvelImage
    let comics: ComicList
    
    static func object(from realmObject: RLMCharacter) -> Character {
        var image: MarvelImage
        if let thumbnail = realmObject.thumbnail {
            image = MarvelImage(path: thumbnail.path, extension: thumbnail.extension)
        } else {
            image = MarvelImage.empty
        }
        var comics: ComicList
        if let comicsList = realmObject.comics {
            comics = ComicList.object(from: comicsList)
        } else {
            comics = ComicList.empty
        }
        return Character(id: realmObject.identifier,
                         name: realmObject.name,
                         description: realmObject.characterDescription,
                         thumbnail: image,
                         comics: comics)
    }
}

class RLMCharacter: Object {
    @objc dynamic var identifier: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var characterDescription: String = ""
    @objc dynamic var thumbnail: RLMMarvelImage? = nil
    @objc dynamic var comics: RLMComicList? = nil
    
    class func object(from character: Character) -> RLMCharacter {
        let object = RLMCharacter()
        object.identifier = character.id
        object.name = character.name
        object.characterDescription = character.description
        object.thumbnail = RLMMarvelImage.object(from: character.thumbnail)
        object.comics = RLMComicList.object(from: character.comics)
        return object
    }
}
