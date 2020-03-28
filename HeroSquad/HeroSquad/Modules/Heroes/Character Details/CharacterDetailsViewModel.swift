import Foundation
import RxSwift
import RxCocoa

struct ComicDisplayItem {
    let comic: Comic
    let imageService: ImageServiceType
    
    func loadImage(size: ImageSize) -> Driver<UIImage?> {
        let url = comic.thumbnail.imageUrl(with: size)
        return self.imageService.loadImage(url: url)
            .asDriver(onErrorDriveWith: .empty())
    }
}

protocol CharacterDetailsViewModelType {
    // Inputs
    var addRemoveFromSquadTrigger: PublishRelay<Void> { get }
    var confirmedFireFromSquad: PublishRelay<Bool> { get }
    
    // Outputs
    var characterImage: Driver<UIImage?> { get }
    var characterName: Driver<String> { get }
    var characterDescription: Driver<String> { get }
    var showsLastAppearedInSection: Driver<Bool> { get }
    var latestComics: Driver<(left: ComicDisplayItem?, right: ComicDisplayItem?)> { get }
    var moreComicsTitle: Driver<String> { get }
    var showsMoreComicsSection: Driver<Bool> { get }
    var characterRecruited: Driver<Bool> { get }
    var confirmToFireFromSquad: Driver<Bool> { get }
}

final class CharacterDetailsViewModel: CharacterDetailsViewModelType {
    let addRemoveFromSquadTrigger = PublishRelay<Void>()
    let confirmedFireFromSquad = PublishRelay<Bool>()
    
    let characterImage: Driver<UIImage?>
    let characterName: Driver<String>
    let characterDescription: Driver<String>
    let showsLastAppearedInSection: Driver<Bool>
    let latestComics: Driver<(left: ComicDisplayItem?, right: ComicDisplayItem?)>
    let moreComicsTitle: Driver<String>
    let showsMoreComicsSection: Driver<Bool>
    
    let characterRecruited: Driver<Bool>
    let confirmToFireFromSquad: Driver<Bool>
    
    init(character: Driver<Character>,
         maxLastAppearItems: Int,
         networking: MarvelAPI,
         imageService: ImageServiceType,
         persistence: MySquadPersistenceLayer) {
        
        let isRecruited = character
            .map { $0.id }
            .map { persistence.exists(characterId: $0) }
        
        let recruitOrFireTrigger = addRemoveFromSquadTrigger
            .withLatestFrom(character)
            .flatMap { character -> Observable<Bool> in
                let exists = persistence.exists(characterId: character.id)
                return Observable.just(exists).scan(exists) { (lastestValue, prev) -> Bool in
                    return !lastestValue
                }
            }.share()
        
        let recruit = recruitOrFireTrigger
            .filter { $0 }
            .withLatestFrom(character)
            .flatMap { character -> Observable<Bool> in
                if !persistence.exists(characterId: character.id) {
                    persistence.add(character: character)
                    return .just(true)
                }
                return .just(false)
            }.asDriver(onErrorJustReturn: false)
        
        let confirmation = self.confirmedFireFromSquad
        
        let fire = recruitOrFireTrigger.filter { !$0 }
            .withLatestFrom(character)
            .flatMap { character -> Observable<Bool> in
                return confirmation.flatMap { shouldFire -> Observable<Bool> in
                    if shouldFire && persistence.exists(characterId: character.id) {
                        persistence.remove(characterId: character.id)
                        return .just(false)
                    }
                    return .just(true)
                }
            }.asDriver(onErrorJustReturn: false)
        
        confirmToFireFromSquad = recruitOrFireTrigger.filter { !$0 }.asDriver(onErrorJustReturn: false)
        
        characterRecruited = Driver<Bool>.merge(isRecruited, recruit, fire)
        
        characterImage = character.flatMapLatest({ character -> Driver<UIImage?> in
            let url = character.thumbnail.imageUrl(with: .xtraLarge(aspectRatio: .square))
            return imageService.loadImage(url: url)
                .asDriver(onErrorJustReturn: nil)
        })
        
        characterName = character.map { $0.name }
        characterDescription = character.map { $0.description }
        
        showsLastAppearedInSection = character
            .map { $0.comics.available > 0 }
            .map { !$0 } // negate for isHidden variable
     
        latestComics = character.asObservable()
            .filter { $0.comics.available > 0 }
            .flatMapLatest { value -> Single<[Comic]> in
                return networking.getComics(characterId: value.id)
                    .map { Array($0.data.results.dropFirst(maxLastAppearItems)) }
            }
            .map({ comics -> (ComicDisplayItem?, ComicDisplayItem?)  in
                let left = comics.last.map { ComicDisplayItem(comic:$0, imageService:imageService) }
                let right = comics.first.map { ComicDisplayItem(comic:$0, imageService:imageService) }
                return (left, right)
            })
            .asDriver(onErrorDriveWith: .empty())
        
        let availableComics = character
            .map { $0.comics }
            .filter { $0.available > maxLastAppearItems }
            .map { comicList -> Int in
                return comicList.available - maxLastAppearItems
            }
        
        moreComicsTitle = availableComics
            .map { comicsCount -> String in
                return "and \(comicsCount) other comic"
            }
        
        showsMoreComicsSection = availableComics
            .map { $0 > 0 }
            .map { !$0 } // negate for isHidden variable
            
    }
    
    
}
