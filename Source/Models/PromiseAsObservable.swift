

import Foundation
import FBLPromises
import Promises
import RxSwift

/// convert objc-promise to Observable
/// can't directly extension FBLPromise<Value> for swift can't extension objc generic class
public extension NSObject {

    func asObservable(on queue: DispatchQueue = DispatchQueue.main)->Observable<AnyObject?> {
        if let p = self as? FBLPromise<AnyObject> {
            return Observable.create { (observer) -> Disposable in
                p.__onQueue(queue, then: {ret in
                    observer.onNext(ret)
                    observer.onCompleted()
                    return nil
                }).__onQueue(queue, catch: {error in
                    observer.onError(error)
                })
                return Disposables.create()
            }
        } else {
            return Observable.create { (observer) -> Disposable in
                observer.onError(SWError.init(msg: "can't generate Observable from NOT-FBLPromise class", code: -1))
                return Disposables.create()
            }
        }
    }
}

/// convert swift-promise to Observable
public extension Promise {

    func asObservable(on queue: DispatchQueue = DispatchQueue.main)->Observable<Value> { // Value is the original class Promise<Value>'s generic type
        return Observable.create { (observer) -> Disposable in
            self.then(on: queue) { ret in
                observer.onNext(ret)
                observer.onCompleted()
            }.catch(on: queue) { error in
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
