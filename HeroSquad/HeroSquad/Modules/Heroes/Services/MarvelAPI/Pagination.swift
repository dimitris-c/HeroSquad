import Foundation
import RxSwift
import RxCocoa

struct PageData<Element> {
    let page: Int
    let element: Element
}

protocol Pagination {
    func paginate<Element>(
        limit: Int,
        query: @escaping (_ limit: Int, _ offset: Int) -> Observable<Element>,
        refreshTrigger: Observable<Void>,
        nextPageTrigger: Observable<Void>
    ) -> Observable<PageData<Element>>
}

final class PaginationService: Pagination {
    
    let loading = BehaviorSubject<Bool>(value: false)
    
    private var currentPage = 0
    private let disposeBag = DisposeBag()

    func paginate<Element>(
        limit: Int,
        query: @escaping (_ limit: Int, _ offset: Int) -> Observable<Element>,
        refreshTrigger: Observable<Void>,
        nextPageTrigger: Observable<Void>
    ) -> Observable<PageData<Element>> {
        let refreshRequest = loading.asObservable()
            .sample(refreshTrigger)
            .flatMap { [weak self] loading -> Observable<Element> in
                guard let self = self else { return .empty() }
                if loading {
                    return .empty()
                } else {
                    self.currentPage = 0
                    let offset = self.currentPage * limit
                    return query(limit, offset)
                }
            }
        
        let nextPageRequest = loading.asObservable()
            .sample(nextPageTrigger)
            .flatMap { [weak self] loading -> Observable<Element> in
                guard let self = self else { return .empty() }
                if loading {
                    return .empty()
                } else {
                    self.currentPage += 1
                    let offset = self.currentPage * limit
                    return query(limit, offset)
                }
            }
        let request = Observable.of(refreshRequest, nextPageRequest).merge().share()
        
        Observable
            .of(request.map { _ in true },
                request.catchError { _ in .empty() }.map { _ in false })
            .merge()
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        return request.flatMap { [weak self] value -> Observable<PageData<Element>> in
            guard let self = self else { return .empty() }
            return .just(PageData(page: self.currentPage, element: value))
        }
    }
    
}
