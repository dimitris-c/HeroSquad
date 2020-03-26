import UIKit

final class HeroesWireframe {
    
    private let marvelApiClient: MarvelAPI
    private let imageService: ImageServiceType
    
    init(marvelApiClient: MarvelAPI, imageService: ImageServiceType) {
        self.marvelApiClient = marvelApiClient
        self.imageService = imageService
    }
    
    func prepareModule() -> UINavigationController {
        
        let pagination = PaginationService()
        let viewModel = HeroesViewModel(marvelApiClient: self.marvelApiClient, pagination: pagination, imageService: imageService)
        let viewController = HeroesViewController(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        return navigationController
    }
    
}
