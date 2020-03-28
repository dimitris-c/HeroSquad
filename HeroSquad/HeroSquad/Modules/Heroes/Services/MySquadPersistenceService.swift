import Foundation
import RxSwift
import RxCocoa
import RealmSwift

protocol MySquadPersistenceLayer {
    func add(character: Character)
    func remove(characterId: Int)
    func exists(characterId: Int) -> Bool
    
    func mySquad() -> Results<RLMCharacter>
}

final class MySquadPersistenceService: MySquadPersistenceLayer {

    func add(character: Character) {
        let realm = try! Realm()
        try? realm.write(withoutNotifying: []) { () -> Void in
            let object = RLMCharacter.object(from: character)
            realm.add(object, update: .error)
        }
    }
    
    func remove(characterId: Int) {
        let realm = try! Realm()
        if let toBeDeleted = realm.objects(RLMCharacter.self).first(where: { $0.identifier == characterId }) {
            try? realm.write(withoutNotifying: []) { () -> Void in
                if let thumbnail = toBeDeleted.thumbnail {
                    realm.delete(thumbnail)
                }
                realm.delete(toBeDeleted)
            }
        }
    }
    
    func exists(characterId: Int) -> Bool {
        return mySquad().filter { $0.identifier == characterId }.first != nil
    }
    
    func mySquad() -> Results<RLMCharacter> {
        let realm = try! Realm()
        return realm.objects(RLMCharacter.self)
    }
}

// MARK: Reactive

extension ObservableType where Element: RealmCollectionValue  {
    static func results(from collection: Results<Element>) -> Observable<Results<Element>> {
        return Observable.create { observer -> Disposable in
            let token = collection.observe { change in

                switch change {
                case .initial(let value):
                    observer.onNext(value)
                case .update(let value, _, _, _):
                    observer.onNext(value)
                case .error(let error):
                    observer.onError(error)
                }
                
            }
            return Disposables.create {
                token.invalidate()
            }
        }
    }
}
