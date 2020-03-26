import Foundation
import RxSwift

protocol CachableImageServiceType {
    func saveImage(image: UIImage, for key: String)
    func retrieveImage(for key: String) -> UIImage?
}

protocol ImageServiceType {
    func loadImage(url: URL?) -> Observable<UIImage?>
}

class ImageService: ImageServiceType {

    private let imageCache: CachableImageServiceType
    private let networking: NetworkingSession
    
    init(cache: CachableImageServiceType, networking: NetworkingSession) {
        self.imageCache = cache
        self.networking = networking
    }

    func loadImage(url: URL?) -> Observable<UIImage?> {
        guard let url = url else { return .just(nil) }
        return Observable.deferred { [weak self] in
            guard let self = self else { return .empty() }
            let imageFromCache = self.imageCache.retrieveImage(for: url.absoluteString)
            if let image = imageFromCache {
                return Observable.just(image)
            }

            return self.networking.response(request: URLRequest(url: url))
                .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
                .map { UIImage(data: $0.data) }
                .do(onNext: { image in
                    if let image = image {
                        self.imageCache.saveImage(image: image, for: url.absoluteString)
                    }
                })
                .catchErrorJustReturn(nil)
        }
    }
    
}

final class ImageCache: CachableImageServiceType {
    
    private let cache: NSCache<AnyObject, UIImage>
    init(cache: NSCache<AnyObject, UIImage>) {
        self.cache = cache
        self.cache.totalCostLimit = 100
    }
    
    func saveImage(image: UIImage, for key: String) {
        self.cache.setObject(image, forKey: key as AnyObject)
    }
    
    func retrieveImage(for key: String) -> UIImage? {
        return self.cache.object(forKey: key as AnyObject)
    }
}
