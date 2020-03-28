import Foundation
import UIKit
import RealmSwift

protocol Services {
    var networkingClient: Networking { get }
    var imageService: ImageServiceType { get }
    var mySquadPersistence: MySquadPersistenceLayer { get }
}

final class ServicesContainer: Services {
    
    lazy var networkingClient: Networking = NetworkingClient()
    
    lazy var imageService: ImageServiceType = {
        return ImageService(cache: ImageCache(cache: NSCache<AnyObject, UIImage>()), networking: URLSession.shared)
    }()
    
    lazy var mySquadPersistence: MySquadPersistenceLayer = {
       return MySquadPersistenceService()
    }()
    
}
