import UIKit

final class HeroesWireframe {
    
    private let marvelApiClient: MarvelAPI
    
    init(marvelApiClient: MarvelAPI) {
        self.marvelApiClient = marvelApiClient
    }
    
    func prepareModule() -> UINavigationController {
        
        let pagination = PaginationService()
        let viewModel = HeroesViewModel(marvelApiClient: self.marvelApiClient, pagination: pagination)
        let viewController = HeroesViewController(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        return navigationController
    }
    
}
