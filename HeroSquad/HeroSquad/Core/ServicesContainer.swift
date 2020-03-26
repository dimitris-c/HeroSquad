import Foundation
import UIKit

protocol Services {
    var networkingClient: Networking { get }
    var imageService: ImageServiceType { get }
}

final class ServicesContainer: Services {
    
    lazy var networkingClient: Networking = NetworkingClient()
    
    lazy var imageService: ImageServiceType = {
        return ImageService(cache: ImageCache(cache: NSCache<AnyObject, UIImage>()), networking: URLSession.shared)
    }()
}
