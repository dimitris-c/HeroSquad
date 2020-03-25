import Foundation

struct DataWrapper<T: Decodable>: Decodable {
    let code: Int
    let data: DataContainer<T>
}

struct DataContainer<T: Decodable>: Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [T]
}
