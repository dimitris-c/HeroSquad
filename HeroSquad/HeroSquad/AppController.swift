import UIKit

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
        return UIViewController()
    }
}
