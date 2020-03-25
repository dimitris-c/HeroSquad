import UIKit

final class AppController {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
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
