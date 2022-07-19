

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
import JXCategoryView


class MainController: UIViewController, JXCategoryViewDelegate, JXCategoryListContainerViewDelegate {

    private var scroll: UIScrollView!
    private var curY: CGFloat = 30
    /// tab header
    private lazy var tabHeaderView:JXCategoryTitleView = {
        let headerView = JXCategoryTitleView()
        headerView.delegate = self
        headerView.backgroundColor = UIColor.clear
        headerView.titles = ["词组", "词根", "派生词", "助记", "柯林斯"]
        headerView.listContainer = self.tabView
        headerView.titleFont = WCWFont.regular(10)
        headerView.titleColor = UIColor.qmui_color(withHexString: "#7A7E9D")
        headerView.titleSelectedFont = WCWFont.medium(10)
        headerView.titleSelectedColor = UIColor.qmui_color(withHexString: "#19263A")
        headerView.cellWidth = 36
        headerView.cellSpacing = 12
        let selectedView = JXCategoryIndicatorBackgroundView()
        selectedView.indicatorWidth = 36
        selectedView.indicatorHeight = 20
        selectedView.indicatorCornerRadius = 10
        selectedView.indicatorColor = UIColor.qmui_color(withHexString: "#7A7E9D")!.withAlphaComponent(0.1)
        headerView.indicators = [selectedView]
        return headerView
    }()
    /// tab内容
    private lazy var tabView:JXCategoryListContainerView = {
        let tabView = JXCategoryListContainerView.init(type: JXCategoryListContainerType.collectionView, delegate: self)!
        tabView.scrollView.backgroundColor = UIColor.clear
        tabView.backgroundColor = UIColor.clear
        tabView.listCellBackgroundColor = UIColor.clear
        tabView.scrollView.isPagingEnabled = true
        return tabView
    }()
    
    @objc dynamic var prop1: CGFloat = 300
    @objc dynamic var prop2: CGSize = CGSize.init(width: 100, height: 200)
    
    lazy var totalHeight1: MutableProperty<CGFloat> = {
        let prop = MutableProperty<CGFloat>.init(0)
        prop <~ SignalProducer.combineLatest(self.reactive.producer(for: \.prop1), self.reactive.producer(for: \.prop2)).map({ (prop1, prop2) in
            print("totalHeight1 calculate by: prop1:\(prop1) prop2:\(prop2)")
            return prop1 + prop2.height
        })
        return prop
    }()
    lazy var totalHeight2: MutableProperty<CGFloat> = {
        let prop = MutableProperty<CGFloat>.init(0)
        prop <~ Signal.combineLatest(self.reactive.signal(for: \.prop1), self.reactive.signal(for: \.prop2)).map({ (prop1, prop2) in
            print("totalHeight2 calculate by: prop1:\(prop1) prop2:\(prop2)")
            return prop1 + prop2.height
        })
        return prop
    }()
    /// 3应该和2一致，因为2 <~尾部的Signal会转成SignalProducer再传给<~的处理程序，就和3完全一致了
    /// 对于2和1比较，虽然2传给combineLatest的signal也会转成producer，但它和1传给combineLatest的producer是完全不同的producer，行为不一样
    lazy var totalHeight3: MutableProperty<CGFloat> = {
        let prop = MutableProperty<CGFloat>.init(0)
        prop <~ SignalProducer.combineLatest(self.reactive.signal(for: \.prop1), self.reactive.signal(for: \.prop2)).map({ (prop1, prop2) in
            print("totalHeight3 calculate by: prop1:\(prop1) prop2:\(prop2)")
            return prop1 + prop2.height
        })
        return prop
    }()
    
    
    
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
        self.addButton(text: "RAC Binding1", action: #selector(actionRACBinding1))
        self.addButton(text: "RAC Binding2", action: #selector(actionRACBinding2))
        self.addButton(text: "RAC Binding3", action: #selector(actionRACBinding3))
        self.addButton(text: "Cha\u{20}rac\u{a0}ter", action: #selector(actionCharacter))
        self.addButton(text: "JXCategoryView", action: #selector(actionJXCategoryView))
        self.addButton(text: "CAGradientLayer", action: #selector(actionCAGradientLayer))
    }

    func addButton(text: String, action: Selector) {
        let btn = xViewFactory.button(withTitle: text, font: xFont.regularPF(withSize: 12), titleColor: xColor.black, bgColor: xColor.clear, borderColor: xColor.black, borderWidth: 0.5)
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.frame = CGRect.init(x: 0.5 * (xDevice.screenWidth() - 200), y: self.curY, width: 200, height: 40)
        btn.tk_exposeContext = TKExposeContext.init(trackingId: "btn-1", userData: nil)
        scroll.addSubview(btn)
        self.curY += 50
    }
    
    @objc func actionCAGradientLayer() {
        let layer = CAGradientLayer()
        layer.locations = [0, 0.9, 1]
        layer.colors = [UIColor.init(white: 0, alpha: 0).cgColor,
                        UIColor.init(white: 0, alpha: 1).cgColor,
                        UIColor.init(white: 0, alpha: 1).cgColor]
        layer.frame = CGRect(x:0, y:self.view.bounds.size.height - 500, width:self.view.bounds.size.width, height:500)
        self.view.layer.addSublayer(layer)
    }
    
    /**
     totalHeight1 calculate by: prop1:300.0 prop2:(100.0, 200.0)
     totalHeight1.producer.startWithValues get: 500.0
     totalHeight1 calculate by: prop1:400.0 prop2:(100.0, 200.0)
     totalHeight1.producer.startWithValues get: 600.0
     totalHeight1 calculate by: prop1:400.0 prop2:(100.0, 300.0)
     totalHeight1.producer.startWithValues get: 700.0
     */
    @objc func actionRACBinding1() {
        self.totalHeight1.producer.startWithValues { height in
            print("totalHeight1.producer.startWithValues get: \(height)")
        }
        xTask.asyncMain(after: 5) {
            self.prop1 = 400
            xTask.asyncMain(after: 5) {
                self.prop2 = CGSize.init(width: 100, height: 300)
            }
        }
    }
    /**
     totalHeight2.producer.startWithValues get: 0.0
     totalHeight2 calculate by: prop1:400.0 prop2:(100.0, 300.0)
     totalHeight2.producer.startWithValues get: 700.0
     */
    @objc func actionRACBinding2() {
        self.totalHeight2.producer.startWithValues { height in
            print("totalHeight2.producer.startWithValues get: \(height)")
        }
        xTask.asyncMain(after: 5) {
            self.prop1 = 400
            xTask.asyncMain(after: 5) {
                self.prop2 = CGSize.init(width: 100, height: 300)
            }
        }
    }
    
    /**
     totalHeight3.producer.startWithValues get: 0.0
     totalHeight3 calculate by: prop1:400.0 prop2:(100.0, 300.0)
     totalHeight3.producer.startWithValues get: 700.0
     */
    @objc func actionRACBinding3() {
        self.totalHeight3.producer.startWithValues { height in
            print("totalHeight3.producer.startWithValues get: \(height)")
        }
        xTask.asyncMain(after: 5) {
            self.prop1 = 400
            xTask.asyncMain(after: 5) {
                self.prop2 = CGSize.init(width: 100, height: 300)
            }
        }
    }
    
    @objc func actionJXCategoryView(){
        self.view.addSubview(self.tabHeaderView)
        self.view.addSubview(self.tabView)
        self.tabView.snp.remakeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(200)
        }
        self.tabHeaderView.snp.makeConstraints { make in
            make.left.equalTo(3)
            make.bottom.equalTo(self.tabView.snp.top)
            make.width.equalTo(36 * 5 + 12 * 6)
            make.height.equalTo(40)
        }
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
    
    // MARK: - JXCategoryViewDelegate
    
    // 点击选中或者滚动选中都会调用该方法
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        if(index % 2 == 0) {
            self.tabView.snp.remakeConstraints { make in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(200)
            }
        }
        else{
            self.tabView.snp.remakeConstraints { make in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(300)
            }
        }
    }
    
    // MARK: - JXCategoryListContainerViewDelegate
    
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return 5
    }
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        let view = UIView()
        if index % 2 == 0 {
            view.backgroundColor = UIColor.red
        }
        else {
            view.backgroundColor = UIColor.blue
        }
        return view
    }
}

extension UIView: JXCategoryListContentViewDelegate {
    public func listView() -> UIView! {
        return self
    }
}
