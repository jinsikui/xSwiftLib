

import Foundation
import FBLPromises
import Promises

/// convert objc FBLPromise<Value> to swift Promise<Value>
/// can't directly extension FBLPromise<Value> for swift can't extension objc generic class
public extension NSObject {

    func asSwiftPromise<Value>()->Promise<Value> {
        if let p = self as? FBLPromise<AnyObject> {
            return Promise<Value>(p)
        } else {
            let p = Promise<Value>.pending()
            p.reject(SWError(msg: "can't generate Promise from NOT-FBLPromise class", code: -1))
            return p
        }
    }
    
    func s_fulfilledPromise<Value>(_ value: Value)->Promise<Value> {
        let p = Promise<Value>.pending()
        p.fulfill(value)
        return p
    }
    
    func s_rejectedPromise<Value>()->Promise<Value> {
        let p = Promise<Value>.pending()
        p.reject(SWError(msg: "manual rejected", code: -1))
        return p
    }
}
