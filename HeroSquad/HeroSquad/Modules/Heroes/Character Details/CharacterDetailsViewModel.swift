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
    var characterImage: Driver<UIImage?> { get }
    var characterName: Driver<String> { get }
    var characterDescription: Driver<String> { get }
    var showsLastAppearedInSection: Driver<Bool> { get }
    var latestComics: Driver<(left: ComicDisplayItem?, right: ComicDisplayItem?)> { get }
    var moreComicsTitle: Driver<String> { get }
    var showsMoreComicsSection: Driver<Bool> { get }
}

final class CharacterDetailsViewModel: CharacterDetailsViewModelType {
    let characterImage: Driver<UIImage?>
    let characterName: Driver<String>
    let characterDescription: Driver<String>
    let showsLastAppearedInSection: Driver<Bool>
    let latestComics: Driver<(left: ComicDisplayItem?, right: ComicDisplayItem?)>
    let moreComicsTitle: Driver<String>
    let showsMoreComicsSection: Driver<Bool>
    
    init(character: Driver<Character>, maxLastAppearItems: Int, networking: MarvelAPI, imageService: ImageServiceType) {
        
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
