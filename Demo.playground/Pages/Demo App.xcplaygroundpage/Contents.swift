//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

extension UIScrollView {
    /// Update contentSize height while scroll view did finish layout all subviews
    public func updateContentViewHeight() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}

extension UIViewController {
    
    var topBarHeight: CGFloat {
        let h = (self.navigationController?.navigationBar.frame.height ?? 0.0)
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + h
        } else {
            return UIApplication.shared.statusBarFrame.size.height + h
        }
    }
}

final class MyViewController : UIViewController {
    
    private var threshold: CGFloat = 200
    
    private lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = .red
        v.delegate = self
        return v
    }()
    
    private let btn1: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Butto 1 Here", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .blue
        return b
    }()
    
    private let btn2: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Butto 2 Here", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .yellow
        return b
    }()
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14.0)
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-64.0)
        }
        
        scrollView.addSubview(btn1)
        btn1.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100.0)
        }
        
        scrollView.addSubview(btn2)
        btn2.snp.makeConstraints { (make) in
//            make.top.equalTo(btn1.snp.bottom).offset(440.0)
            make.top.equalTo(btn1.snp.bottom).offset(1440.0)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100.0)
        }
        navigationItem.title = "標題"
        
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.bottom.centerX.width.equalToSuperview()
            make.height.equalTo(64.0)
        }
    }
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         scrollView.updateContentViewHeight()
     }
}

extension MyViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let panGestureRecognizer = scrollView.panGestureRecognizer
        let velocity = panGestureRecognizer.velocity(in: scrollView)
        let y = velocity.y

        if (y > 0) {
            print("下滑，畫面往上")
            if (self.navigationController?.navigationBar.isHidden ?? true) {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }
        } else if (y < 0) {
            /// 滿足 offset 大於某個的高度才會觸發
            let satisfy = scrollView.contentOffset.y > threshold
            /// 當 contentSize 的高度大於 frame + topBarHeight 的高度才放行
            if scrollView.contentSize.height > scrollView.frame.height + topBarHeight && satisfy {
                print("上滑，畫面往下")
                if !(navigationController?.navigationBar.isHidden ?? false) {
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                }
            }
        } else {
            print("y == 0")
        }
    }
}


let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 768, height: 1024))
window.rootViewController = UINavigationController(rootViewController: MyViewController())
window.makeKeyAndVisible()
PlaygroundPage.current.liveView = window
