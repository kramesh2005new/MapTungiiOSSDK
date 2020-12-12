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
    
    private var rotateTimer : Timer?
    var imgRotate : UIImageView?
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
        
        var arrImage: [UIImage] = []
        
        arrImage.append( UIImage(named: "Logo1", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)!)
        arrImage.append( UIImage(named: "Logo2", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)!)
        arrImage.append( UIImage(named: "Logo3", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)!)
        arrImage.append( UIImage(named: "Logo4", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)!)
        
        let imgFullBg = UIImageView(frame: CGRect(x: -12, y: -12, width: progressBar.frame.size.width + 24, height: progressBar.frame.size.height + 24))
        imgFullBg.image = UIImage(named: "whitebackground", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)
        imgFullBg.backgroundColor = .clear
        progressBar.addSubview(imgFullBg)
        
        self.imgRotate = UIImageView(frame: CGRect(x: -8, y: -8, width: progressBar.frame.size.width + 16, height: progressBar.frame.size.height + 16))
        self.imgRotate!.image = UIImage(named: "loader", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)
        self.imgRotate!.backgroundColor = .clear
        progressBar.addSubview(self.imgRotate!)
        
        let imgFull = UIImageView(frame: CGRect(x: 15, y: 15, width: progressBar.frame.size.width - 30, height: progressBar.frame.size.height - 30))
        imgFull.image = UIImage(named: "LogoFull", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)
        imgFull.backgroundColor = .clear
        progressBar.addSubview(imgFull)
        
        
        let imgLoader = UIImageView(frame: CGRect(x: 10, y: 10, width: progressBar.frame.size.width - 20, height: progressBar.frame.size.height - 20))
       
        imgLoader.animationImages = arrImage
        imgLoader.layer.makeAnimationsPersistent()
        imgLoader.animationDuration = 0.5
        imgLoader.startAnimating()
        imgLoader.backgroundColor = .clear
        progressBar.addSubview(imgLoader)
        self.backgroundColor = .clear
        
        self.imgRotate?.rotate()
        
        self.startRotateTimer()
    }
    
    func startRotateTimer()
    {
        self.rotateTimer =  Timer.scheduledTimer(timeInterval: 1.10, target: self, selector: #selector(self.rotateLoader), userInfo: nil, repeats: true)
    }
    
    @objc func rotateLoader()
    {
        self.imgRotate?.rotate()
        
        stopRotateTimer()
        self.rotateTimer =  Timer.scheduledTimer(timeInterval: 1.10, target: self, selector: #selector(self.rotateLoader), userInfo: nil, repeats: true)
    }

    func stopRotateTimer()
    {
        if self.rotateTimer != nil
        {
            self.rotateTimer!.invalidate()
            self.rotateTimer = nil
        }
    }
    
    func stopAnimating() {
        progressBar.rotate360Degrees(isRemove: true)
    }
}
