//
//  ParentViewController.swift
//  Mapconfig
//
//  Created by Arunkumar Porchezhiyan on 28/07/20.
//  Copyright © 2020 zvky. All rights reserved.
//

import UIKit

import SystemConfiguration
public class ParentViewController: UIViewController, UIScrollViewDelegate {
    let loaderVw = Loader()
    var imgStaticBg: UIImageView!
    var imgEntering: UIImageView!
    var scrollViewStatic: UIScrollView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    /// This method is used to call the api
    func callApi() {
    }
}

// MARK: - Activity Indicator
extension ParentViewController {
    /// This method is used to start the loader
    func startAnimate() {
        loaderVw.frame = view.bounds
        self.loaderVw.center = self.view.center
        self.view.addSubview(loaderVw)
        loaderVw.backgroundColor = UIColor.clear
        loaderVw.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin]
        loaderVw.startAnimating()
        
    }
    /// This method to stop the loader
    func stopAnimate() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.loaderVw.stopAnimating()
            self.loaderVw.removeFromSuperview()
            
        }
    }
    
    //This method to show static map on first time loading
    func showStaticMap()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            //let pgHeight : CGFloat = 5.0
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
                
            }){ (finished) in
                
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.imgStaticBg.isHidden = false
            self.imgEntering.isHidden = false
            self.view.backgroundColor = UIColor(red: 197.0/255, green: 223.0/255, blue: 178.0/255, alpha: 1.0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) {
            
            self.scrollViewStatic = UIScrollView(frame: self.view.bounds)
            
            self.imgStaticBg  = UIImageView(image:  UIImage(named: "temp_bg_image", in: Bundle(for: MapViewVC.self),       compatibleWith: nil))
            
            self.imgStaticBg.frame = CGRect(x: UIApplication.shared.statusBarFrame.height
                , y: self.view.bounds.origin.y, width: self.view.bounds.size.width - (UIApplication.shared.statusBarFrame.height)
                , height: self.view.bounds.size.height ) //self.view.bounds
            
            self.imgStaticBg.contentMode = .scaleAspectFill
            self.imgStaticBg.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin]
            self.imgStaticBg.isHidden = true
            self.view.addSubview(self.imgStaticBg)
            
            
            self.imgEntering = UIImageView(frame: CGRect(x:(self.view.bounds.size.width - 262) / 2 , y: self.view.bounds.size.height - 50, width: 262, height: 40))
            
            
            self.imgEntering.image = UIImage(named: "entring1.png", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)
            
            self.imgEntering.autoresizingMask = [ .flexibleBottomMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin]
            self.view.addSubview(self.imgEntering)
            self.imgEntering.isHidden = true
            
            self.view.bringSubview(toFront: self.loaderVw)
            
        }
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgStaticBg
    }
    
    //This method to hide the static map
    func hideStaticMap()
    {
        if self.imgStaticBg != nil
        {
           self.imgEntering.isHidden = true
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                
                // HERE
                self.imgStaticBg.transform = CGAffineTransform.identity.scaledBy(x: 3, y: 3) // Scale your image
                
                self.imgStaticBg.alpha = 0
                
            }) { (finished) in
                
                self.imgStaticBg.removeFromSuperview()
                self.imgEntering.removeFromSuperview()
            }
        }
    }
}

extension UIViewController {
    /// Shows alert with no action for ok button
    /// - Parameters:
    ///   - title: Title to show on alert
    ///   - message: Message to show on alert
    ///   - completion: handler function to perform after presenting alert
    func showAlertWithTitle(title: String?, message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            completion!()
        }))
        //self.present(alert, animated: true, completion: completion)
        self.present(alert, animated: true, completion: nil)
    }    
    /// Check the internet connection in the application
    func checkReachable() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(SCNetworkReachabilityCreateWithName(nil, "https://www.google.com")!, &flags)
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return (isReachable && (!needsConnection || canConnectWithoutUserInteraction))
    }
}

extension ParentViewController: UIGestureRecognizerDelegate {
    
    private func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                   shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
