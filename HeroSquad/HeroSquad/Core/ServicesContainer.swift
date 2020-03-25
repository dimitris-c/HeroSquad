import Foundation

protocol Services {
    var networkingClient: Networking { get }
}

final class ServicesContainer: Services {
    
    lazy var networkingClient: Networking = NetworkingClient()
    
}
