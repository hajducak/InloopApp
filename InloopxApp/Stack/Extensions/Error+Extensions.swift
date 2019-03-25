
import Foundation
import RxSwift

extension Error {
    func asServiceError<T: Any>(messages: [Int : String] = [:]) -> Observable<Lce<T>> {
        if let serviceError = self as? ServiceError {
            return Observable.just(Lce(error: serviceError))
        } else {
            print(self)
            return Observable.error(self)
        }
    }
}
