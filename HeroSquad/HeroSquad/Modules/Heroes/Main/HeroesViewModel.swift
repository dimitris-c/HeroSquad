import Foundation
import RxSwift
import RxCocoa

struct HeroDisplayItemViewModel {
    let character: Character
    private let imageService: ImageServiceType
    
    var name: String { character.name }
    
    var id: Int { character.id }
    
    init(from character: Character, imageService: ImageServiceType) {
        self.character = character
        self.imageService = imageService
    }
    
    func loadImage(with size: ImageSize) -> Driver<UIImage?> {
        let imageUrl = self.character.thumbnail.imageUrl(with: size)
        return self.imageService
            .loadImage(url: imageUrl)
            .asDriver(onErrorJustReturn: nil)
    }
}

protocol HeroesViewModelType {
    // Inputs
    var viewLoaded: PublishRelay<Void> { get }
    var nextPageTriggered: PublishRelay<Void> { get }
    var heroSelected: PublishRelay<HeroDisplayItemViewModel> { get }
    
    // Outputs
    var heroes: Driver<[HeroDisplayItemViewModel]> { get }
}

final class HeroesViewModel: HeroesViewModelType {
    
    // MARK: Inputs
    let viewLoaded = PublishRelay<Void>()
    let nextPageTriggered = PublishRelay<Void>()
    let heroSelected = PublishRelay<HeroDisplayItemViewModel>()
    
    // MARK: Outputs
    let heroes: Driver<[HeroDisplayItemViewModel]>
    
    // MARK: Route
    let navigable: HeroesNavigable
    
    private let marvelApiClient: MarvelAPI
    private let pagination: Pagination
    
    let loading = PublishRelay<Bool>()
    
    init(marvelApiClient: MarvelAPI, pagination: Pagination, imageService: ImageServiceType, navigable: HeroesNavigable) {
        self.marvelApiClient = marvelApiClient
        self.pagination = pagination
        self.navigable = navigable
        
        let query: (Int, Int) -> Observable<DataWrapper<Character>> = { limit, offset -> Observable<DataWrapper<Character>> in
            return marvelApiClient.getCharacters(limit: limit, offset: offset).asObservable()
        }
        
        self.heroes = pagination.paginate(limit: 20,
                                          query: query,
                                          refreshTrigger: viewLoaded.asObservable().map { _ in },
                                          nextPageTrigger: nextPageTriggered.asObservable().map { _ in })
            .scan(into: [HeroDisplayItemViewModel](), accumulator: { (values, pageData) in
                let converted = pageData.element.data.results.map { character -> HeroDisplayItemViewModel in
                    return HeroDisplayItemViewModel(from: character, imageService: imageService)
                }
                values = pageData.page == 0 ? converted : values + converted
            })
            .asDriver(onErrorJustReturn: [])
            
        let displayHero = heroSelected
            .map { HeroesFlow.displayHero(character: $0.character) }
            .asSignal(onErrorSignalWith: .empty())
        
        navigable.route(to: displayHero)
    }
    
}
