import Foundation
import RxSwift
import RxCocoa

struct HeroDisplayItem {
    let imageUrl: URL?
    let name: String
    let id: Int
    
    init(from character: Character) {
        self.imageUrl = character.thumbnail.imageUrl
        self.name = character.name
        self.id = character.id
    }
}

protocol HeroesViewModelType {
    // Inputs
    var viewLoaded: PublishRelay<Void> { get }
    var nextPageTriggered: PublishRelay<Void> { get }
    
    // Outputs
    var heroes: Driver<[HeroDisplayItem]> { get }
}

final class HeroesViewModel: HeroesViewModelType {
    // MARK: Inputs
    let viewLoaded = PublishRelay<Void>()
    let nextPageTriggered = PublishRelay<Void>()
    
    // MARK: Outputs
    let heroes: Driver<[HeroDisplayItem]>
    
    private let marvelApiClient: MarvelAPI
    private let pagination: Pagination
    
    let loading = PublishRelay<Bool>()
    
    init(marvelApiClient: MarvelAPI, pagination: Pagination) {
        self.marvelApiClient = marvelApiClient
        self.pagination = pagination
        
        let query: (Int, Int) -> Observable<DataWrapper<Character>> = { limit, offset -> Observable<DataWrapper<Character>> in
            return marvelApiClient.getCharacters(limit: limit, offset: offset).asObservable()
        }
        
        self.heroes = pagination.paginate(limit: 20,
                                          query: query,
                                          refreshTrigger: viewLoaded.asObservable().map { _ in },
                                          nextPageTrigger: nextPageTriggered.asObservable().map { _ in })
            .scan(into: [HeroDisplayItem](), accumulator: { (values, pageData) in
                let converted = pageData.element.data.results.map(HeroDisplayItem.init(from:))
                values = pageData.page == 0 ? converted : values + converted
            })
            .asDriver(onErrorJustReturn: [])
            
       
            
    }
    
}
