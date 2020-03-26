import Foundation

enum ImageAspectRatio: String {
    case portait
    case square
    case landscape
}

enum ImageSize {
    case normal
    case small(aspectRatio: ImageAspectRatio)
    case medium(aspectRatio: ImageAspectRatio)
    case xtraLarge(aspectRatio: ImageAspectRatio)
    case fantastic(aspectRatio: ImageAspectRatio)
    case uncanny(aspectRatio: ImageAspectRatio)
    case incredible(aspectRatio: ImageAspectRatio)
    
    var value: String {
        switch self {
        case .normal:
            return ""
        case .small(let aspectRatio):
            return "\(aspectRatio.rawValue)_small"
        case .medium(let aspectRatio):
            return "\(aspectRatio.rawValue)_medium"
        case .xtraLarge(let aspectRatio):
            return "\(aspectRatio.rawValue)_xlarge"
        case .fantastic(let aspectRatio):
            return "\(aspectRatio.rawValue)_fantastic"
        case .uncanny(let aspectRatio):
            return "\(aspectRatio.rawValue)_uncanny"
        case .incredible(let aspectRatio):
            return "\(aspectRatio.rawValue)_incredible"
        }
    }
}

struct MarvelImage: Decodable {
    let path: String
    let `extension`: String
    
    func imageUrl(with size: ImageSize) -> URL? {
        guard case .normal = size else { 
            let urlString = "\(self.path).\(self.extension)"
            return URL(string: urlString)
        }
        let urlString = "\(self.path)/\(size.value)/.\(self.extension)"
        return URL(string: urlString)
    }
}
