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
    let progressView = UIProgressView()
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
        loaderVw.frame = view.bounds// CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: self.view.frame.size.width)
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
            //self.imgStaticBg.removeFromSuperview()
            
            //self.hideStaticMap()
            
        }
    }
    
    
    func showStaticMap()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            let pgHeight : CGFloat = 5.0
            
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                pgHeight = 10
//            }
            
                   UIView.animate(withDuration: 0.5, animations: {
                   
                       self.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
                       self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
                     self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: pgHeight)//CGAffineTransform(scaleX: 1.0, y: pgHeight)
                    
                   }){ (finished) in
                      
                       //self.progressView.layer.cornerRadius = 20 // pgHeight
                                                                
                       //self.progressView.layer.sublayers![1].cornerRadius = 20 //pgHeight
                       
                   }
               }
               
               DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.imgStaticBg.isHidden = false
                   self.imgEntering.isHidden = false
//                self.scrollViewStatic.isHidden = false
                self.progressView.isHidden = false
               }
               
               DispatchQueue.main.asyncAfter(deadline: .now() ) {
                
                self.scrollViewStatic = UIScrollView(frame: self.view.bounds)
                //self.scrollViewStatic.backgroundColor = UIColor.blue
                self.imgStaticBg  = UIImageView(image:  UIImage(named: "temp_bg_image", in: Bundle(for: MapViewVC.self),       compatibleWith: nil))
                            
                self.imgStaticBg.frame = self.view.bounds //CGRect(x: 0, y: 0, width: (self.imgStaticBg.image?.size.width)!, height: (self.imgStaticBg.image?.size.height)!)
//                self.scrollViewStatic.contentSize = self.imgStaticBg.bounds.size
                
                            
                //self.scrollViewStatic.backgroundColor = UIColor.yellow
//                self.scrollViewStatic.translatesAutoresizingMaskIntoConstraints = false;
//                self.scrollViewStatic.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin]
//
//                var  zoomScale = self.view.bounds.size.width / self.imgStaticBg.image!.size.height;
//                var isChanged : Bool = false
//
//                if (self.imgStaticBg.image!.size.width * zoomScale) < self.view.bounds.size.height
//                {
//                    zoomScale = self.view.bounds.size.height / self.imgStaticBg.image!.size.width;
//                    isChanged = true
//                }
//                //        }
//                //        else
//                //        {
//                //            zoomScale = self.view.bounds.size.height / self.imageView.image!.size.height;
//                //        }
//
//                //        if (zoomScale > 1) {
//                //            self.scrollView.minimumZoomScale = 1;
//                //            zoomScale = 1
//                //        }
//
//                        self.scrollViewStatic.minimumZoomScale = zoomScale;
//
//
//                  // self.imgStaticBg = UIImageView(frame: self.view.bounds) // CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: self.view.frame.size.width))
//                   self.scrollViewStatic.center = self.view.center
//                   //self.imgStaticBg.image = UIImage(named: "temp_bg_image.jpg", in: Bundle(for: MapViewVC.self),       compatibleWith: nil) // UIImage(named: "toggle.png") //temp_bg_image.jpg
                   self.imgStaticBg.contentMode = .scaleAspectFill
                   self.imgStaticBg.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin]
//                   //self.scrollViewStatic.addSubview(self.imgStaticBg)
                   self.imgStaticBg.isHidden = true
//                self.scrollViewStatic.maximumZoomScale = 2.0
//                self.scrollViewStatic.showsVerticalScrollIndicator = false
//                self.scrollViewStatic.showsHorizontalScrollIndicator = false
//                self.scrollViewStatic.delegate = self
//                self.scrollViewStatic.zoomScale = zoomScale;
                //self.view.addSubview(self.scrollViewStatic)
                self.view.addSubview(self.imgStaticBg)
                   
                
                
//                if (self.view.bounds.size.width / zoomScale) < self.imgStaticBg.image!.size.width
//                {
//                    self.scrollViewStatic.setContentOffset(
//                    CGPoint(x: self.scrollViewStatic.contentSize.width - self.scrollViewStatic.bounds.size.width, y:  (self.scrollViewStatic.contentSize.height / zoomScale) - self.scrollViewStatic.bounds.size.height),
//                                animated: true)
//                }
                
//                if isChanged
//                {
//                    self.scrollViewStatic.setContentOffset(
//                    CGPoint(x: self.scrollViewStatic.contentSize.width - self.scrollViewStatic.bounds.size.width, y:  73 ),
//                                animated: true)
//                }
//                else
//                {
//                    self.scrollViewStatic.setContentOffset(
//                    CGPoint(x: self.scrollViewStatic.contentSize.width - self.scrollViewStatic.bounds.size.width, y:  0),
//                                animated: true)
//                }
                   
                   self.imgEntering = UIImageView(frame: CGRect(x:(self.view.bounds.size.width - 262) / 2 , y: self.view.bounds.size.height - 50, width: 262, height: 40))
//
//                 if UIDevice.current.userInterfaceIdiom == .pad {
                    
//                self.imgEntering.frame = CGRect(x:self.imgStaticBg.bounds.size.width - 420 , y: self.imgStaticBg.bounds.size.height - 70, width: 382, height: 60)
                    
//                }
                
                
                   self.imgEntering.image = UIImage(named: "entring1.png", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)
                   
                   self.imgEntering.autoresizingMask = [ .flexibleBottomMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin]
                   self.view.addSubview(self.imgEntering)
                   self.imgEntering.isHidden = true
                   //self.view.bringSubview(toFront: self.imgEntering) self.view.bounds.size.height - 35  self.view.bounds.size.width - 220
                   
                 
                let pgWidth = self.view.frame.size.width / 2
                       
//                if UIDevice.current.userInterfaceIdiom == .pad {
//                    pgWidth = self.view.frame.size.width - 400
//                }
                
                let pgHeight : CGFloat = 5.0
                
//                if UIDevice.current.userInterfaceIdiom == .pad {
//                    pgHeight = 10.0
//                }
                
                self.progressView.frame = CGRect(x: (self.view.frame.size.width - pgWidth)/2 , y:   (self.view.center.y + (self.loaderVw.progressBar.frame.size.height/2) + 100) , width: pgWidth, height: 50)
                self.progressView.progress = 0.0
                self.progressView.autoresizingMask = [.flexibleWidth , .flexibleBottomMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin]
                self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: pgHeight)// CGAffineTransform(scaleX: 1.0, y: pgHeight)
                self.progressView.progressTintColor = UIColor.white
                self.progressView.trackTintColor = UIColor.lightGray
//                self.progressView.layer.cornerRadius = pgHeight / 2
//                self.progressView.clipsToBounds = true
//                self.progressView.layer.sublayers![1].cornerRadius = pgHeight / 2
//                self.progressView.subviews[1].clipsToBounds = true
                self.progressView.isHidden = true
                self.view.addSubview(self.progressView)
                
                 self.view.bringSubview(toFront: self.loaderVw)
                
               }
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgStaticBg
    }
    
    func hideStaticMap()
    {
        if self.imgStaticBg != nil
        {
            self.stopAnimate()
            self.imgEntering.isHidden = true
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    
                   // HERE
                self.imgStaticBg.transform = CGAffineTransform.identity.scaledBy(x: 3, y: 3) // Scale your image
               //self.imgStaticBg.transform = CGAffineTransform(translationX: -30, y: 0)
                
                self.imgStaticBg.alpha = 0

             }) { (finished) in
               
                self.imgStaticBg.removeFromSuperview()
                //self.scrollViewStatic.removeFromSuperview()
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
