import Foundation

struct MarvelImage: Decodable {
    let path: String
    let `extension`: String
    
    var imageUrl: URL? {
        let urlString = "\(self.path).\(self.extension)"
        return URL(string: urlString)
    }
}
