import UIKit
import RxSwift
import RxCocoa

enum HeroesFlow {
    case displayHero(character: Character)
}
protocol HeroesNavigable {
    func route(to flow: Signal<HeroesFlow>)
}

final class HeroesWireframe: HeroesNavigable {
    private let disposeBag = DisposeBag()
    
    private let marvelApiClient: MarvelAPI
    private let imageService: ImageServiceType
    private var navigationController: UINavigationController?
    
    init(marvelApiClient: MarvelAPI, imageService: ImageServiceType) {
        self.marvelApiClient = marvelApiClient
        self.imageService = imageService
    }
    
    func prepareModule() -> UINavigationController {
        
        let pagination = PaginationService()
        let viewModel = HeroesViewModel(marvelApiClient: self.marvelApiClient,
                                        pagination: pagination,
                                        imageService: imageService,
                                        navigable: self)
        let viewController = HeroesViewController(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController = navigationController
        
        return navigationController
    }
    
    func route(to flow: Signal<HeroesFlow>) {
        flow.emit(onNext: { [weak self] flow in
            guard let self = self else { return }
            switch flow {
            case .displayHero(let character):
                self.displayCharacterDetails(with: character)
            }
        }).disposed(by: disposeBag)
    }
    
    private func displayCharacterDetails(with character: Character) {
        let viewModel = CharacterDetailsViewModel(character: .just(character),
                                                  maxLastAppearItems: 2,
                                                  networking: self.marvelApiClient,
                                                  imageService: self.imageService)
        let viewController = CharacterDetailsViewController(viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
