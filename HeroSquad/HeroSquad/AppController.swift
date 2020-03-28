import UIKit
import RxSwift
import RealmSwift
final class AppController {
    
    private let window: UIWindow
    private let container: Services
    
    init(window: UIWindow, container: Services) {
        self.window = window
        self.container = container
    }
    
    func start() {
        self.window.rootViewController = buildMain()
        self.window.makeKeyAndVisible()
}
    
    
    // MARK: Private
    
    func buildMain() -> UIViewController {
        let credentials = MarvelAPICredentials(timestamp: { String(Int(Date().timeIntervalSince1970)) },
                                               apiKey: MarvelAPIConfig.apiKey,
                                               privateKey: MarvelAPIConfig.privateKey)
        let marvelAPIClient = MarvelAPIClient(networking: self.container.networkingClient,
                                              credentials: credentials,
                                              baseURL: MarvelAPIConfig.gateway.baseURL!)
        let heroesWireframe = HeroesWireframe(marvelApiClient: marvelAPIClient,
                                              imageService: container.imageService,
                                              persistence: container.mySquadPersistence)
        return heroesWireframe.prepareModule()
    }
}
