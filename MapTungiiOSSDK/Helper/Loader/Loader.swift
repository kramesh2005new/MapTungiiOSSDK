/*
 * VideoDetailViewController
 * This class  is used as custom loader of UIView
 * @category   Entertainment
 * @package    com.ssowri1.HOOQ-Task-Sowrirajan
 * @version    1.0
 * @author     ssowri1@gmail.com
 */
import UIKit
import WebKit
class Loader: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var progressBar: UIView!
    
    
    // Programatic purposs
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    // Storyboard/Xib purposs
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        let bundle = Bundle(for: Loader.self)
        bundle.loadNibNamed("Loader", owner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = .clear
        contentView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
    func startAnimating() {
        let bundle = Bundle(for: Loader.self)
        let webview = WKWebView()
        webview.backgroundColor = .clear
        webview.frame  = CGRect(x: 0, y: 0, width: progressBar.frame.size.width, height: progressBar.frame.size.height)
        webview.load(URLRequest(url: bundle.url(forResource: "index", withExtension:"html")! as URL) as URLRequest)
//        progressBar.addSubview(webview)
        var arrImage: [UIImage] = []
        
        arrImage.append( UIImage(named: "Logo1", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)!)
        arrImage.append( UIImage(named: "Logo2", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)!)
        arrImage.append( UIImage(named: "Logo3", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)!)
        arrImage.append( UIImage(named: "Logo4", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)!)
//        arrImage.append( UIImage(named: "LogoFull", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)!)
        
        let imgFull = UIImageView(frame: CGRect(x: 5, y: 5, width: progressBar.frame.size.width - 10, height: progressBar.frame.size.height - 10))
        imgFull.image = UIImage(named: "LogoFull", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)
        imgFull.backgroundColor = .clear
        progressBar.addSubview(imgFull)
        
        
        let imgLoader = UIImageView(frame: CGRect(x: 0, y: 0, width: progressBar.frame.size.width, height: progressBar.frame.size.height))
       
        imgLoader.animationImages = arrImage
        imgLoader.layer.makeAnimationsPersistent()
        imgLoader.animationDuration = 0.5
        imgLoader.startAnimating()
        imgLoader.backgroundColor = .clear
        progressBar.addSubview(imgLoader)
        self.backgroundColor = .clear
        
    }
    
    func stopAnimating() {
        progressBar.rotate360Degrees(isRemove: true)
    }
}
