

import UIKit
import xUtil
import xUI
import SnapKit
import RxSwift
import SwiftyJSON
import xAPI
import xTracking

class MainController: UIViewController {

    private var scroll: UIScrollView!
    private var curY: CGFloat = 30

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "xSwiftLib test"
        self.view.backgroundColor = xColor.fromRGB(0xFFFFFF)
        self.navigationController?.navigationBar.isTranslucent = false
        scroll = UIScrollView()
        self.view.addSubview(scroll)
        scroll.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.addButton(text: "Promise to Observable", action: #selector(actionPromiseToObservable))
    }

    func addButton(text: String, action: Selector) {
        let btn = xViewFactory.button(withTitle: text, font: xFont.regularPF(withSize: 12), titleColor: xColor.black, bgColor: xColor.clear, borderColor: xColor.black, borderWidth: 0.5)
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.frame = CGRect.init(x: 0.5 * (xDevice.screenWidth() - 200), y: self.curY, width: 200, height: 40)
        btn.tk_exposeContext = TKExposeContext.init(trackingId: "btn-1", userData: nil)
        scroll.addSubview(btn)
        self.curY += 50
    }

    @objc func actionPromiseToObservable() {
        xTask.asyncGlobal {
            _ = xAPI.host("https://api.androidhive.info").path("/volley/person_object.json").method(.HTTP_GET).execute().asObservable().subscribe { (ret) in
                // this must be true because asObservable() perform underlying promise method then() and other block on main thread
                print("is main thread? \(Thread.isMainThread)")

                if let dic = ret as? [AnyHashable: Any] {
                    print("API ret as Dictionary (could pass to params of NSDictionary type): \n\(dic)")
                }
                if let ret = ret {
                    let json = JSON.init(ret)
                    print("API ret as SwiftyJSON (for operate in swift): \n\(json)")
                }
            } onError: { (error) in
                print(error)
            }
        }
    }
}
