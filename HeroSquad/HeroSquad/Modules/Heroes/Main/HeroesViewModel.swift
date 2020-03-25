import Foundation

protocol HeroesViewModelType {
    
}

final class HeroesViewModel: HeroesViewModelType {
    
    private let marvelApiClient: MarvelAPI
    
    init(marvelApiClient: MarvelAPI) {
        self.marvelApiClient = marvelApiClient
    }
    
}
