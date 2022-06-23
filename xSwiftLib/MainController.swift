

import UIKit
import xUtil
import xUI
import SnapKit
import RxSwift
import SwiftyJSON
import xAPI
import xTracking
import ReactiveSwift
import ReactiveCocoa
import QMUIKit
import Masonry


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
        self.addButton(text: "RAC Property", action: #selector(actionRACProperty))
        self.addButton(text: "hot signal", action: #selector(actionHotSignal))
        self.addButton(text: "RAC KVO", action: #selector(actionRACKvo))
        self.addButton(text: "Cha\u{20}rac\u{a0}ter", action: #selector(actionCharacter))
    }

    func addButton(text: String, action: Selector) {
        let btn = xViewFactory.button(withTitle: text, font: xFont.regularPF(withSize: 12), titleColor: xColor.black, bgColor: xColor.clear, borderColor: xColor.black, borderWidth: 0.5)
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.frame = CGRect.init(x: 0.5 * (xDevice.screenWidth() - 200), y: self.curY, width: 200, height: 40)
        btn.tk_exposeContext = TKExposeContext.init(trackingId: "btn-1", userData: nil)
        scroll.addSubview(btn)
        self.curY += 50
    }
    
    let specialCharacters:[Character] = ["\u{200b}","\u{2018}","\u{2019}","\u{20}","\u{21}","\u{25}","\u{26}","\u{2026}","\u{27}","\u{28}","\u{29}","\u{2c}","\u{2d}","\u{2e}","\u{2f}","\u{3d}","\u{3f}","\u{5f}","\u{2160}","\u{2161}","\u{a0}","\u{20ac}","\u{b0}"]
    
    @objc func actionCharacter(){
        let str:String = "Cha\u{20}rac\u{a0}\u{25}ter"
        print(str)
        var newStr:String = ""
        for c in str {
            if !specialCharacters.contains(c) {
                newStr.append(c)
            }
        }
        print(newStr)
    }
    
    // 每秒发送一个text的子串
    func textSignalGenerator(text: String) -> Signal<String, Never> {
        return Signal<String, Never> { (observer, _) in
            let now = DispatchTime.now()
            for index in 0..<text.count {
                DispatchQueue.main.asyncAfter(deadline: now + 1.0 * Double(index)) {
                    let indexStartOfText = text.index(text.startIndex, offsetBy: 0)
                    let indexEndOfText = text.index(text.startIndex, offsetBy: index)
                    let substring = text[indexStartOfText...indexEndOfText]
                    let value = String(substring)
                    observer.send(value: value)
                }
            }
        }
    }
    
    // the property to kvo must marked as @objc dynamic, and must not swift-only type like enum
    @objc dynamic var name:String = "batman"
    @objc func actionRACKvo(){
        /**
         kvo received name: batman
         kvo received name: spiderman
         kvo received name: superman
         */
        // producer emit the initial value "batman", signal not.
        self.reactive.producer(for: \.name).startWithValues { name in
            print("kvo received name: \(name)")
        }
        xTask.asyncGlobal(after: 2) {
            self.name = "spiderman"
            xTask.asyncGlobal(after: 2) {
                self.name = "superman"
            }
        }
    }
    
    @objc func actionHotSignal(){
        /**
         observe 1 received: b
         observe 1 received: ba
         observe 1 received: bat
         observe 1 received: batm
         observe 1 received: batma
         observe 2 received: batma
         observe 1 received: batman
         observe 2 received: batman
         */
        let signal = self.textSignalGenerator(text: "batman");
        signal.observeValues { text in
            print("observe 1 received: \(text)")
        }
        xTask.asyncMain(after: 3) {
            signal.observeValues { text in
                print("observe 2 received: \(text)")
            }
        }
    }
    
    @objc func actionRACProperty(){
        /**
         producer received 3
         producer received 4
         producer received 5
         signal received 5
         */
        let mutableProperty = MutableProperty(1)
        mutableProperty.value = 2
        mutableProperty.value = 3
        mutableProperty.producer.startWithValues{
            print("producer received \($0)")
        }
        mutableProperty.value = 4
        mutableProperty.signal.observeValues {
            print("signal received \($0)")
        }
        mutableProperty.value = 5
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
