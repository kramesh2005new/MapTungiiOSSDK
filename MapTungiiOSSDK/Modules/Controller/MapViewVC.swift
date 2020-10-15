//
//  ViewController.swift
//  mapconfig
//
//  Created by Arunkumar Porchezhiyan on 27/07/20.
//  Copyright © 2020 zvky. All rights reserved.
//

import UIKit
import Foundation
import Zip

public protocol CallbackSDK: class {
    func actionMore(pivotID: Int)
}

public class MapViewVC: ParentViewController, UIScrollViewDelegate {
    
    let assetsApiModel = AssetsApiModel(apiClient: APIClient())
    var assetsResponse: AssestsModel!
    var pivotResponse: PivotModel?
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var imageHouse: UIImageView!
    var arrStatic: [UIImage] = []
    var arrImage: [UIImage] = []
    var arrTitle: [UIImage] = []
    var animeassets: String!
    var captionView: customPopup!
    var versionNo: Int!
    var senderAction: UIButton?
    public static var delegate: CallbackSDK?
    public static var resortID: Int!
    
    var zoomScale : CGFloat = 1.0
    var currentZoomScale : CGFloat = 1.0
    
    var isOrientationToggled : Bool = false
    
    var bgEffectToLoad: Int = 1
    var treeBunchEffectToLoad: Int = 1
    
    var popupWidth : CGFloat = 320
    var popupHeight : CGFloat = 160
   
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let defaults = UserDefaults.standard
        versionNo = defaults.integer(forKey: "version")
        createFolderInDocumentDirectory()
        callAssestsWebService()
        //setUpStaticAssests()
        //getAnimationConfiguration()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            popupWidth = 380
            
            popupHeight = 170
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
//        self.edgesForExtendedLayout = []
    }
            
    // Create a folder in DocumentDirectory to store the files retrive from the server
    func createFolderInDocumentDirectory()
     {
       let fileManager = FileManager.default
       let PathWithFolderName = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("map_assets")
       
       print("Document Directory Folder Path :- ",PathWithFolderName)
           
       if !fileManager.fileExists(atPath: PathWithFolderName)
       {
           try! fileManager.createDirectory(atPath: PathWithFolderName, withIntermediateDirectories: true, attributes: nil)
       }
     }
    
    // To get the Directory path of the files which stored from the server.
    func getDirectoryPath() -> URL
    {
        let documentDirectoryPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
        let pathWithFolderName = documentDirectoryPath.appendingPathComponent("map_assets")
        let url = URL(string: pathWithFolderName) // convert path in url
          
        return url!
    }
    
    // Calling the Server to get the assets URL to download the static assests and animation assets
    func callAssestsWebService(){
        assetsApiModel.getAssetsWebservice(parent: self, resort:MapViewVC.resortID, { (result) in
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    self.assetsResponse = items
                    if (self.versionNo == self.assetsResponse.data?.version){
                        self.setUpStaticAssests()
                        self.getAnimationConfiguration()
                        self.bgEffectToLoad = 5
                        self.getBGEffectConfiguration()
                        self.treeBunchEffectToLoad = 1
                        self.getTreeBunchConfiguration()
                        self.treeBunchEffectToLoad = 2
                        self.getTreeBunchConfiguration()
                        self.treeBunchEffectToLoad = 3
                        self.getTreeBunchConfiguration()
                        self.treeBunchEffectToLoad = 4
                        self.getTreeBunchConfiguration()
                        self.treeBunchEffectToLoad = 6
                        self.getTreeBunchConfiguration()
                        self.getStaicAssestConfiguration()
                        self.bgEffectToLoad = 2
                        self.getBGEffectConfiguration()
                        self.bgEffectToLoad = 3
                        self.getBGEffectConfiguration()
                        self.bgEffectToLoad = 4
                        self.getBGEffectConfiguration()
                        self.callPivotPointWebService()
                        self.geBirdAnimationConfiguration()
                        self.getTitleAssestConfiguration()
                    }else{
//                        self.callDownloadStaticAssets()
                        self.downloadAndLoadMapBg()
                    }
                    let defaults = UserDefaults.standard
                    defaults.set(self.assetsResponse.data?.version, forKey: "version")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlertWithTitle(title: "Oops!",
                                        message: "Something went wrong")
                }
                print("\(self) retrive error on get flights: \(error)")
            }
        })
    }
    
    // Calling the server to get the Pivot points
    func callPivotPointWebService(){
        assetsApiModel.getPivotWebservice(parent: self, resort:MapViewVC.resortID, { (result) in
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    self.pivotResponse = items
                    self.getPivotPointConfiguration()
                    self.geBirdAnimationConfiguration()
                    self.getTitleAssestConfiguration()
                }
            case .failure(let error):
                print("\(self) retrive error on get flights: \(error)")
            }
        })
    }
    
    func downloadAndLoadMapBg()
    {
        let fileName : String = "map_bg.png"
        
         var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL.appendPathComponent(fileName)
        try? FileManager.default.removeItem(at: documentsURL)
        let url = URL(string: (self.assetsResponse?.data?.staticMapAssets?.filter{$0.assetName == "map_bg"}.first?.assetUrl!)!)
        
        let request = URLRequest(url:url!)
        self.startAnimate()
        assetsApiModel.downloadAssets(parent: self, from:"Static", downloadURL: request, { (result) in
            switch result {
            case .success(let items):
                do {
                try FileManager.default.copyItem(at: items, to: documentsURL)
                DispatchQueue.main.async {
                    self.downloadAndLoadMapHouse()
//                    self.setUpStaticAssests()
                   //self.callDownloadAnimationAssets()
                    }}catch (let writeError) {
                print("Error creating a file \(documentsURL) : \(writeError)")
            }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlertWithTitle(title: "Oops!",
                                        message: "Something went wrong")
                }
                print("\(self) retrive error on get flights: \(error)")
            }
        })
        
        
    }
    
    func downloadAndLoadMapHouse()
    {
        let fileName : String = "map_houses.png"
        
         var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL.appendPathComponent(fileName)
        try? FileManager.default.removeItem(at: documentsURL)
        let url = URL(string: (self.assetsResponse?.data?.staticMapAssets?.filter{$0.assetName == "map_houses"}.first?.assetUrl!)!)
        
        let request = URLRequest(url:url!)
        
        assetsApiModel.downloadAssets(parent: self, from:"Static", downloadURL: request, { (result) in
            self.stopAnimate()
            switch result {
            case .success(let items):
                do {
                try FileManager.default.copyItem(at: items, to: documentsURL)
                DispatchQueue.main.async {
                    self.setUpStaticAssests()
                    self.callDownloadBGEffects1()
                   //self.callDownloadAnimationAssets()
                    }}catch (let writeError) {
                print("Error creating a file \(documentsURL) : \(writeError)")
            }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlertWithTitle(title: "Oops!",
                                        message: "Something went wrong")
                }
                print("\(self) retrive error on get flights: \(error)")
            }
        })
        
        
    }
    
    //Download the static assests and store it in the DocumentDirectory folder and unzip the folder in the map_assests.
    func callDownloadStaticAssets(){
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL.appendPathComponent("Static_BG.zip")
        try? FileManager.default.removeItem(at: documentsURL)
//        let url = URL(string: (self.assetsResponse?.data?.staticMapAssets?[0].assetUrl!)!)
        let url = URL(string: (self.assetsResponse?.data?.staticMapAssets?.filter{$0.assetName == "Static_BG"}.first?.assetUrl!)!)
        let request = URLRequest(url:url!)
        
        assetsApiModel.downloadAssets(parent: self, from:"Static", downloadURL: request, { (result) in
            switch result {
            case .success(let items):
                do {
                try FileManager.default.copyItem(at: items, to: documentsURL)
                DispatchQueue.main.async {
                   self.unZipAssets(filePath : documentsURL, from: "Static")
                    self.getStaicAssestConfiguration()
                    self.bgEffectToLoad = 2
                    self.callDownloadBGEffects()
//                   self.callDownloadAnimationAssets()
                    }}catch (let writeError) {
                print("Error creating a file \(documentsURL) : \(writeError)")
            }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlertWithTitle(title: "Oops!",
                                        message: "Something went wrong")
                }
                print("\(self) retrive error on get flights: \(error)")
            }
        })
    }

    //Download the animation assests and store it in the DocumentDirectory folder and unzip the folder in the map_assests.
    func callDownloadAnimationAssets(){
         var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
         documentsURL.appendPathComponent("map_assets/animation_assets_19.zip")
         try? FileManager.default.removeItem(at: documentsURL)
         let url = URL(string: (self.assetsResponse?.data?.animationAssets![0].assetUrl!)!)
         let request = URLRequest(url:url!)
        
        assetsApiModel.downloadAssets(parent: self, from:"Animation", downloadURL: request, { (result) in
            switch result {
            case .success(let items):
                do {
                try FileManager.default.copyItem(at: items, to: documentsURL)
                DispatchQueue.main.async {
                   self.unZipAssets(filePath : documentsURL, from: "Animation")
                    }}catch (let writeError) {
                print("Error creating a file \(documentsURL) : \(writeError)")
            }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlertWithTitle(title: "Oops!",
                                        message: "Something went wrong")
                }
                print("\(self) retrive error on get flights: \(error)")
            }
        })
    }
    
    //Download the BG Effects1 and store it in the DocumentDirectory folder and unzip it.
    func callDownloadBGEffects1(){
         var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
         documentsURL.appendPathComponent("BG_Effects_1.zip")
         try? FileManager.default.removeItem(at: documentsURL)
//         let url = URL(string: (self.assetsResponse?.data?.animationAssets![0].assetUrl!)!)
         let url = URL(string: (self.assetsResponse?.data?.animationAssets?.filter{$0.assetname == "BG_Effects_1"}.first?.assetUrl!)!)
         let request = URLRequest(url:url!)
        
        assetsApiModel.downloadAssets(parent: self, from:"Animation", downloadURL: request, { (result) in
            
            switch result {
            case .success(let items):
                do {
                try FileManager.default.copyItem(at: items, to: documentsURL)
                DispatchQueue.main.async {
                   self.unZipAssets(filePath : documentsURL, from: "Animation")
                    self.getAnimationConfiguration()
                    self.bgEffectToLoad = 5
                    self.callDownloadBGEffects()
                    }}catch (let writeError) {
                print("Error creating a file \(documentsURL) : \(writeError)")
            }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlertWithTitle(title: "Oops!",
                                        message: "Something went wrong")
                }
                print("\(self) retrive error on get flights: \(error)")
            }
        })
    }
    
     //Download the BG Effects and store it in the DocumentDirectory folder and unzip it.
     func callDownloadBGEffects(){
             var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
             documentsURL.appendPathComponent("BG_Effects_\(bgEffectToLoad).zip")
             try? FileManager.default.removeItem(at: documentsURL)
    //         let url = URL(string: (self.assetsResponse?.data?.animationAssets![0].assetUrl!)!)
             let url = URL(string: (self.assetsResponse?.data?.animationAssets?.filter{$0.assetname == "BG_Effects_\(bgEffectToLoad)"}.first?.assetUrl!)!)
             let request = URLRequest(url:url!)
            
            assetsApiModel.downloadAssets(parent: self, from:"Animation", downloadURL: request, { (result) in
                switch result {
                case .success(let items):
                    do {
                    try FileManager.default.copyItem(at: items, to: documentsURL)
                    DispatchQueue.main.async {
                       self.unZipAssets(filePath : documentsURL, from: "Animation")
                        self.getBGEffectConfiguration()
                        if self.bgEffectToLoad == 5
                        {
                            self.callDownloadTreeBunchEffects()
                        }
                        else if self.bgEffectToLoad < 4
                        {
                            self.bgEffectToLoad += 1
                            self.callDownloadBGEffects()
                        }
                        else if self.bgEffectToLoad == 4
                        {
                            self.callDownloadTungiPopupImages()
                            
                        }
                        
                        }}catch (let writeError) {
                    print("Error creating a file \(documentsURL) : \(writeError)")
                }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlertWithTitle(title: "Oops!",
                                            message: "Something went wrong")
                    }
                    print("\(self) retrive error on get flights: \(error)")
                }
            })
        }
    
     //Download the Tree Bunch Effects and store it in the DocumentDirectory folder and unzip it.
    func callDownloadTreeBunchEffects(){
             var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
             documentsURL.appendPathComponent("Tree_Bunch_\(treeBunchEffectToLoad).zip")
             try? FileManager.default.removeItem(at: documentsURL)
    //         let url = URL(string: (self.assetsResponse?.data?.animationAssets![0].assetUrl!)!)
             let url = URL(string: (self.assetsResponse?.data?.animationAssets?.filter{$0.assetname == "Tree_Bunch_\(treeBunchEffectToLoad)"}.first?.assetUrl!)!)
             let request = URLRequest(url:url!)
            
            assetsApiModel.downloadAssets(parent: self, from:"Animation", downloadURL: request, { (result) in
                switch result {
                case .success(let items):
                    do {
                    try FileManager.default.copyItem(at: items, to: documentsURL)
                    DispatchQueue.main.async {
                       self.unZipAssets(filePath : documentsURL, from: "Animation")
                        self.getTreeBunchConfiguration()
                        if self.treeBunchEffectToLoad <= 3
                        {
                            self.treeBunchEffectToLoad += 1
                            self.callDownloadTreeBunchEffects()
                        }
                        else if self.treeBunchEffectToLoad == 4
                        {
                            self.treeBunchEffectToLoad += 2
                            self.callDownloadTreeBunchEffects()
                        }
                        else if self.treeBunchEffectToLoad == 6
                        {
                            self.callDownloadStaticAssets()
                        }
                        
                        }}catch (let writeError) {
                    print("Error creating a file \(documentsURL) : \(writeError)")
                }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlertWithTitle(title: "Oops!",
                                            message: "Something went wrong")
                    }
                    print("\(self) retrive error on get flights: \(error)")
                }
            })
        }
    
     //Download the Popup images and store it in the DocumentDirectory folder and unzip it.
    func callDownloadTungiPopupImages(){
             var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
             documentsURL.appendPathComponent("Tungi_Popup_Images.zip")
             try? FileManager.default.removeItem(at: documentsURL)
    //         let url = URL(string: (self.assetsResponse?.data?.animationAssets![0].assetUrl!)!)
             let url = URL(string: (self.assetsResponse?.data?.animationAssets?.filter{$0.assetname == "Tungi_Popup_images"}.first?.assetUrl!)!)
             let request = URLRequest(url:url!)
            
            assetsApiModel.downloadAssets(parent: self, from:"Animation", downloadURL: request, { (result) in
                switch result {
                case .success(let items):
                    do {
                    try FileManager.default.copyItem(at: items, to: documentsURL)
                    DispatchQueue.main.async {
                       self.unZipAssets(filePath : documentsURL, from: "Animation")
                        self.callPivotPointWebService()
                        }}catch (let writeError) {
                    print("Error creating a file \(documentsURL) : \(writeError)")
                }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlertWithTitle(title: "Oops!",
                                            message: "Something went wrong")
                    }
                    print("\(self) retrive error on get flights: \(error)")
                }
            })
        }
           
    //To Unzip the assests in the DocumentDirectory
    func unZipAssets(filePath: URL, from: String){
        
        var folderName = filePath.lastPathComponent
        folderName = folderName.replacingOccurrences(of: ".zip", with: "")
        do {
            var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsDirectory = documentsDirectory.appendingPathComponent(folderName)
//            let fileURL = URL(fileURLWithPath: documentsDirectory.absoluteString)
            try? FileManager.default.removeItem(at: documentsDirectory)
            try Zip.unzipFile(filePath, destination: documentsDirectory, overwrite: true, password: "password", progress: { (progress) -> () in
            }) // Unzip
            if from == "Static" {
                
            }else{
                //setUpStaticAssests()
//                getAnimationConfiguration()
                //callPivotPointWebService()
            }
        }
        catch {
          print("Something went wrong")
        }
    }
  
    // To setup the static assests from the document directory and image scrollview zoom and pinch gesture
    func setUpStaticAssests(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        do{
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let mapURL = documentsURL.appendingPathComponent("map_bg.png")
            //let mapfileURLs = URL(fileURLWithPath: mapURL.absoluteString)
            let mapimage = UIImage(data: try Foundation.Data(contentsOf: mapURL))
            imageView = UIImageView(image: mapimage)
            let houseURL = documentsURL.appendingPathComponent("map_houses.png")
//            let housefileURLs = URL(fileURLWithPath: houseURL.absoluteString)
            let houseimage = UIImage(data: try Foundation.Data(contentsOf: houseURL))
            imageHouse = UIImageView(image: houseimage)
        }catch{
            print("Error while enumerating files in the Document Directory")
        }
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        scrollView = UIScrollView(frame: view.bounds)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
//            scrollView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
            scrollView.contentSize = imageView.bounds.size
            scrollView.setContentOffset(
                CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 0),
            animated: true)
        }else{
//            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            scrollView.contentSize = imageView.bounds.size
            scrollView.setContentOffset(
                CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 100),
            animated: true)
        }
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin]
        scrollView.delegate = self
        
//        let widthScale = self.view.bounds.size.width / imageView.bounds.width
//           let heightScale = self.view.bounds.size.height / imageView.bounds.height
//           let scale = min(widthScale,heightScale)
//           scrollView.minimumZoomScale = scale
        
        zoomScale = self.view.bounds.size.height / self.imageView.image!.size.height;

//        if (zoomScale > 1) {
//            self.scrollView.minimumZoomScale = 1;
//            zoomScale = 1
//        }

        self.scrollView.minimumZoomScale = zoomScale;
        
        self.currentZoomScale = zoomScale
//        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        imageView.addSubview(imageHouse)
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        self.scrollView.zoomScale = zoomScale;
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.bouncesZoom = false
        scrollView.bounces = false
        
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            scrollView.zoomScale = 1.1
//        }
        setUpOrienttaion()
        
    }
    
    func setUpOrienttaion() {
            
        let btnOrientation = UIButton()
        let image = UIImage(named: "toggle", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)
        btnOrientation.setBackgroundImage(image, for: .normal)
        btnOrientation.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btnOrientation.addTarget(self, action: #selector(actionOrientationTapped), for: .touchUpInside)
        btnOrientation.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnOrientation)
        btnOrientation.bringSubview(toFront: imageView)
        btnOrientation.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        btnOrientation.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive = true
        btnOrientation.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnOrientation.heightAnchor.constraint(equalToConstant: 50).isActive = true
        setUpBackButton()
    }
    
    func setUpBackButton(){
        let btnBack = UIButton()
        let image = UIImage(named: "back", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)
        btnBack.setBackgroundImage(image, for: .normal)
        btnBack.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnBack.addTarget(self, action: #selector(actionbackTapped), for: .touchUpInside)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnBack)
        btnBack.bringSubview(toFront: imageView)
        btnBack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        btnBack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: 40).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        setUpToggleTittle()
    }
    
    func setUpToggleTittle() {
            
        let btnToggle = UIButton()
        btnToggle.backgroundColor = UIColor.white
        btnToggle.layer.cornerRadius = 25
        btnToggle.titleLabel?.numberOfLines = 0
        btnToggle.titleLabel?.lineBreakMode = .byWordWrapping
        btnToggle.setTitle("See\nLess", for: .normal)
        btnToggle.titleLabel?.textAlignment = .center
        btnToggle.setTitleColor(UIColor.black, for: .normal)
        btnToggle.titleLabel?.font = UIFont(name: "system", size: 8)
        btnToggle.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btnToggle.addTarget(self, action: #selector(actionToggleTapped), for: .touchUpInside)
        btnToggle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnToggle)
        btnToggle.bringSubview(toFront: imageView)
        btnToggle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        btnToggle.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -82).isActive = true
        btnToggle.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnToggle.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func actionbackTapped(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func actionOrientationTapped(sender: UIButton) {
        if sender.isSelected {
            self.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.height, height: self.view.bounds.size.width)
            sender.isSelected = false
//            if UIDevice.current.userInterfaceIdiom == .phone {
                scrollView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
//            }
        } else {
            sender.isSelected = true
            print(CGFloat(-Double.pi/2))
            self.view.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
//            if UIDevice.current.userInterfaceIdiom == .phone {
                scrollView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
//            }
        }
        
        isOrientationToggled = true
    }
    
    @objc func actionToggleTapped(sender: UIButton) {
        if sender.isSelected {
            for view in imageView.subviews{
                if view.tag == 1000 {
                    view.isHidden = false
                }
            }
            sender.isSelected = false
            sender.titleLabel?.numberOfLines = 0
            sender.titleLabel?.lineBreakMode = .byWordWrapping
            sender.setTitle("See\nLess", for: .normal)
            sender.titleLabel?.textAlignment = .center
            sender.setTitleColor(UIColor.black, for: .normal)
        } else {
            for view in imageView.subviews{
                if view.tag == 1000 {
                    view.isHidden = true
                }
            }
            sender.titleLabel?.numberOfLines = 0
            sender.titleLabel?.lineBreakMode = .byWordWrapping
            sender.setTitle("See\nAll", for: .normal)
            sender.titleLabel?.textAlignment = .center
            sender.setTitleColor(UIColor.black, for: .normal)
            sender.isSelected = true            
        }
    }
    
    // To get the animation configuration from the local bundle.
    func getAnimationConfiguration(){
        let bundle = Bundle(for: MapViewVC.self)
        let animationAssets = bundle.decode("Assestconfig.json")

        for i in 0..<animationAssets.animationFrames!.count {
            getAnimationAssest(item: animationAssets.animationFrames![i])
        }

    }
    
    // To get the BG Effect configuration from the local bundle.
    func getBGEffectConfiguration(){
        let bundle = Bundle(for: MapViewVC.self)
        let animationAssets = bundle.decode("Assestconfig.json")
        
        var effects = animationAssets.bgeffects5!
        
        switch bgEffectToLoad {
        case 2:
            effects = animationAssets.bgeffects2!
        case 3:
            effects = animationAssets.bgeffects3!
        case 4:
            effects = animationAssets.bgeffects4!
        case 5:
            effects = animationAssets.bgeffects5!
        default:
            break
        }
        
        
        for i in 0..<effects.count {
            setEffectsAssest(item: effects[i], folderName: "BG_Effects_\(bgEffectToLoad)/" )
        }
        
    }
    
    // To get the Title Asset configuration from the local bundle.
    func getTitleAssestConfiguration(){
        let bundle = Bundle(for: MapViewVC.self)
        let animationAssets = bundle.decode("Assestconfig.json")
        
        for i in 0..<animationAssets.title!.count {
            getTitleAssest(item: animationAssets.title![i], index:i)
        }
    }
    
    // To get the Pivot point configuration from the local bundle.
    func getPivotPointConfiguration(){
        let bundle = Bundle(for: MapViewVC.self)
        let animationAssets = bundle.decode("Assestconfig.json")
        
        for i in 0..<animationAssets.pivot!.count {
            setPivotAssest(item: animationAssets.pivot![i])
        }
    }
    
    // To get the Static asset configuration from the local bundle.
    func getStaicAssestConfiguration(){
        let bundle = Bundle(for: MapViewVC.self)
        let animationAssets = bundle.decode("Assestconfig.json")
        
        for i in 0..<animationAssets.staticAssets!.count {
            setStaticAssest(item: animationAssets.staticAssets![i])
        }
        
    }
    
    // To get the Bird Animation configuration from the local bundle.
    func geBirdAnimationConfiguration(){
        let bundle = Bundle(for: MapViewVC.self)
        let animationAssets = bundle.decode("Assestconfig.json")
        
        for i in 0..<animationAssets.birdAnimation!.count {
            setEffectsAssest(item: animationAssets.birdAnimation![i], folderName: "BG_Effects_5/")
        }
        
    }
    
    // To get the Tree bunch configuration from the local bundle.
    func getTreeBunchConfiguration(){
        let bundle = Bundle(for: MapViewVC.self)
        let animationAssets = bundle.decode("Assestconfig.json")
        
        var effects = animationAssets.bgeffectsTree1
        
        switch treeBunchEffectToLoad {
        case 1:
            effects = animationAssets.bgeffectsTree1
        case 2:
            effects = animationAssets.bgeffectsTree2
        case 3:
            effects = animationAssets.bgeffectsTree3
        case 4:
            effects = animationAssets.bgeffectsTree4
        case 6:
            effects = animationAssets.bgeffectsTree6
        default:
            break
        }
        
        for i in 0..<effects!.count {
            setEffectsAssest(item: effects![i], folderName: "")
        }
        
    }
    
    //To get the static assests from the document directory and constructing array of image
    func setStaticAssest (item: StaticAssets){
            arrStatic = []
            let fileManager = FileManager.default
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL = documentsURL.appendingPathComponent("Static_BG/\(item.name ?? "")")
            
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: [.nameKey])
                for i in 0..<fileURLs.count {
                    let image = UIImage(data: try Foundation.Data(contentsOf: fileURLs[i]))
                    arrStatic.append(image!)
                }
                setUpStaticBGAssests(item:item)
            } catch {
                print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            }
    }
    
    // Create imageview and bind the image from the document directory
    func setUpStaticBGAssests (item: StaticAssets){
        let staticView = UIImageView()
        staticView.animationImages = arrStatic
        staticView.startAnimating()
        imageView.addSubview(staticView)
        staticView.frame = CGRect(x: item.xPosition!, y: item.yPosition!, width: item.width!, height: item.height!)

    }
    
    //To get the animation assests from the document directory and constructing array of image for animation
    func getAnimationAssest (item: AnimationFrames){
            arrImage = []
            let fileManager = FileManager.default
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL = documentsURL.appendingPathComponent("BG_Effects_1/\(item.name ?? "")")
            
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: [.nameKey])
                for i in 0..<fileURLs.count {
                    var url = fileURLs[i].deletingLastPathComponent()
                    if i > 9 {
                        url = url.appendingPathComponent("\(item.imgName ?? "")" + "_" + "\(i)" + ".png")}
                    else{
                        url = url.appendingPathComponent("\(item.imgName ?? "")" + "_0" + "\(i)" + ".png")}
                    let image = UIImage(data: try Foundation.Data(contentsOf: url))
                    arrImage.append(image!)
                }
                setUpAnimationAssests(item:item)
            } catch {
                print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            }
    }
    
    // Create imageview and button. settup the imageview animation and event add for UIbutton
    func setUpAnimationAssests (item: AnimationFrames){
        let animationView = UIImageView()
        animationView.animationImages = arrImage
        animationView.animationDuration = 1.0
        animationView.startAnimating()
        imageView.addSubview(animationView)
        animationView.frame = CGRect(x: item.imgxPosition!, y: item.imgyPosition!, width: item.imgwidth!, height: item.imgheight!)
    }
    
    //To get the Title assests from the document directory and constructing array of image for animation
    func getTitleAssest (item: Title, index:Int){
            arrTitle = []
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            if item.value == 0 {
                documentsURL = documentsURL.appendingPathComponent("Static_BG/Green Labels/\(item.name ?? "")" + ".png")
            }else{
                documentsURL = documentsURL.appendingPathComponent("Static_BG/Orange Labels/\(item.name ?? "")" + ".png")
            }            
            do {
                //let url = documentsURL.appendingPathComponent("\(item.name ?? "")" + ".png")
                let imageURL = URL(fileURLWithPath: documentsURL.path)
                let image = UIImage(data: try Foundation.Data(contentsOf: imageURL))
                arrTitle.append(image!)
                setUpTitleAssests(item:item)
                
            } catch {
                print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            }
    }
    
    // Create imageview and settup the image
    func setUpTitleAssests (item: Title){
        let titleView = UIImageView()
        titleView.animationImages = arrTitle
        titleView.startAnimating()
        imageView.addSubview(titleView)
        titleView.frame = CGRect(x: item.xPosition!, y: item.yPosition!, width: item.width!, height: item.height!)
        
        if item.value == 0 {
            titleView.tag = 1000
        }
        
        if item.value == 1 {
            let btnPivot = UIButton()
            btnPivot.frame = CGRect(x: item.xPosition!, y: item.yPosition!, width: item.width!, height: item.height!)
            btnPivot.tag = item.id!
            btnPivot.addTarget(self, action: #selector(actionAssestsTapped), for: .touchUpInside)
            imageView.addSubview(btnPivot)
        }
    }
    
    // Create Pivot imageview and set up the image
    func setPivotAssest (item: Pivot){
        let pivotView = UIImageView()
        pivotView.image = UIImage(named: "star", in: Bundle(for: MapViewVC.self),       compatibleWith: nil)
        imageView.addSubview(pivotView)
        pivotView.frame = CGRect(x: item.xPosition!, y: item.yPosition!, width: item.width!, height: item.height!)
        
//        let btnPivot = UIButton()
//        btnPivot.frame = CGRect(x: item.btnxPosition!, y: item.btnyPosition!, width: item.btnwidth!, height: item.btnheight!)
//        btnPivot.tag = item.id!
//        btnPivot.addTarget(self, action: #selector(actionAssestsTapped), for: .touchUpInside)
//        imageView.addSubview(btnPivot)
    }
    
    func setEffectsAssest (item: Bgeffects, folderName: String){
            arrImage = []
            let fileManager = FileManager.default
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL = documentsURL.appendingPathComponent("\(folderName)\(item.name ?? "")")
            
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: [.nameKey])
                for i in 0..<fileURLs.count {
                    var url = fileURLs[i].deletingLastPathComponent()
                    if i > 9 {
                        url = url.appendingPathComponent("\(item.imgName ?? "")" + "_" + "\(i)" + ".png")}
                    else{
                        url = url.appendingPathComponent("\(item.imgName ?? "")" + "_0" + "\(i)" + ".png")}
                    let image = UIImage(data: try Foundation.Data(contentsOf: url))
                    arrImage.append(image!)
                }
                setUpEffectsAssests(item:item)
            } catch {
                print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            }
    }
    
    func setUpEffectsAssests (item: Bgeffects){
        let animationView = UIImageView()
        animationView.animationImages = arrImage
        animationView.animationDuration = 2.0
        animationView.startAnimating()
        imageView.addSubview(animationView)
        animationView.frame = CGRect(x: item.xPosition!, y: item.yPosition!, width: item.width!, height: item.height!)
        
        if item.name == "Bird_Pink" {
            animationView.transform = animationView.transform.rotated(by: 250)
        }else if item.name == "Bird_Blue" {
            animationView.transform = animationView.transform.rotated(by: 70.5)
        }else if item.name == "Bird_Yellow" {
            animationView.transform = animationView.transform.rotated(by: 60)
        }
        
        if item.animate == 1 {
            if item.name == "Pool_Girl_1" {
                self.animation(viewAnimation: animationView, x:0, y:20, time: 3)
            }else if item.name == "Pool_Girl_2" {
                self.animation(viewAnimation: animationView, x:10, y:0, time: 3)
            }else if item.name == "Pool_Girl_3" {
                self.animation(viewAnimation: animationView, x:20, y:0, time: 3)
            }else if item.name == "Pool_Girl_4" {
                self.animation(viewAnimation: animationView, x:15, y:10, time: 3)
            }else if item.name == "Mom_Kid_Walk 3-4" {
                self.animation(viewAnimation: animationView, x:80, y:28, time: 15)
            }else if item.name == "Father_Son_Walk 3-4" {
                self.animation(viewAnimation: animationView, x:-40, y:30, time: 10)
            }
        }
        
        if item.animate == 2 {
            if item.name == "Bird_White" {
                self.animationBird(viewAnimation: animationView, x:1980, y:32, time: 30)
            }else if item.name == "Bird_Pink" {
                self.animationBird(viewAnimation: animationView, x:-350, y:-1080, time: 30)
            }else if item.name == "Bird_Blue" {
                self.animationBird(viewAnimation: animationView, x:1600, y:395, time: 30)
            }else if item.name == "Bird_Yellow" {
                self.animationBird(viewAnimation: animationView, x:-1940, y:450, time: 30)
            }
        }
    }
    
    func animation(viewAnimation: UIImageView, x: CGFloat, y: CGFloat, time:
    TimeInterval) {
        UIView.animate(withDuration: time, delay: 0, options: [.repeat,.autoreverse], animations: {
            viewAnimation.frame = viewAnimation.frame.offsetBy(dx: x, dy: y)
        })
    }
    
    func animationBird(viewAnimation: UIImageView, x: CGFloat, y: CGFloat, time:
    TimeInterval) {
        UIView.animate(withDuration: time, delay: 0, options: [], animations: {
            viewAnimation.frame = viewAnimation.frame.offsetBy(dx: x, dy: y)
        }, completion: {
            (value: Bool) in
            viewAnimation.isHidden = true
        })
    }
    
        
    // Zoom the image using gesture and pan the image
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        let statHeight = UIApplication.shared.statusBarFrame.height * -1
        
        if scale > zoomScale  //&& UIDevice.current.userInterfaceIdiom == .phone
        {
            scrollView.contentInset = UIEdgeInsets(top: statHeight, left: 0, bottom: 0, right: 0)
        }
        else
        {
            if isOrientationToggled // && UIDevice.current.userInterfaceIdiom == .phone
            {
                scrollView.contentInset = UIEdgeInsets(top: statHeight, left: 0, bottom: 0, right: 0)
            }
            else
            {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
        
        self.currentZoomScale = scale
        
        if self.captionView != nil
        {
                
            self.captionView.transform = CGAffineTransform(scaleX: 1.0/scale, y: 1.0/scale)
            
            var yPosition = senderAction!.frame.origin.y - self.captionView.frame.size.height
            
            if senderAction!.tag == 1 || senderAction!.tag == 9 || senderAction!.tag == 10 || senderAction!.tag == 11 {
                
                yPosition = senderAction!.frame.origin.y + senderAction!.frame.size.height
            }
            
            captionView.frame = CGRect(x: self.captionView.frame.origin.x, y: yPosition, width: self.captionView.frame.size.width, height: self.captionView.frame.size.height)
            
            if (senderAction!.tag == 2 || senderAction!.tag == 8) //&& UIDevice.current.userInterfaceIdiom == .phone
            {
                let xPosition = (senderAction!.frame.origin.x + senderAction!.frame.size.width) - self.captionView.frame.size.width
                
                captionView.frame = CGRect(x: xPosition, y: yPosition, width: self.captionView.frame.size.width, height: self.captionView.frame.size.height)
            }
            if senderAction!.tag == 10
            {
                let xPosition = (senderAction!.frame.origin.x + senderAction!.frame.size.width) - self.captionView.frame.size.width
                
                 captionView.frame = CGRect(x: xPosition, y: yPosition, width: self.captionView.frame.size.width, height: self.captionView.frame.size.height)
            }
        }
    }
    
    
    //UIbutton event for the assests.
    @objc func actionAssestsTapped(sender: UIButton) {
        
        senderAction = sender
        
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL = documentsURL.appendingPathComponent("Static_BG/Popup")
        
        if captionView != nil {
            captionView.removeFromSuperview()
        }
        
        if ((self.pivotResponse?.data?.pivotPoints) != nil) {
            let filterArray = self.pivotResponse!.data?.pivotPoints!.filter() { $0.pivotId == String(sender.tag) }
            if filterArray!.count > 0 {
//                if sender.tag == 2 {
//                    captionView = customPopup(frame: CGRect(x: sender.frame.origin.x-175, y: sender.frame.origin.y-170, width: 360, height: 180))
//                }else{
                  //  captionView = customPopup(frame: CGRect(x: (sender.frame.origin.x ) - ((130 * self.currentZoomScale) * (1.0/self.currentZoomScale)) , y: (sender.frame.origin.y) - ((220 * self.currentZoomScale) * (1.0/self.currentZoomScale)), width: 360, height: 180))
                    
                if sender.tag == 1 || sender.tag == 9 || sender.tag == 10 || sender.tag == 11 {
                    
                    if sender.tag == 10
                    {
                        let xPosition = (senderAction!.frame.origin.x + senderAction!.frame.size.width) - (popupWidth * 1/currentZoomScale)
                        
                         captionView = customPopup(frame: CGRect(x: xPosition, y: sender.frame.origin.y + (sender.frame.size.height ), width: popupWidth, height: popupHeight))
                    }
                    else
                    {
                         captionView = customPopup(frame: CGRect(x: sender.frame.origin.x-((popupWidth/2) - (sender.frame.size.width / 2)), y: sender.frame.origin.y + (sender.frame.size.height ), width: popupWidth, height: popupHeight))
                    }
                   
                }
                else if (sender.tag == 2 || sender.tag == 8) //&& UIDevice.current.userInterfaceIdiom == .phone
                {
                   
                    let xPosition = (senderAction!.frame.origin.x + senderAction!.frame.size.width) - (popupWidth * 1/currentZoomScale)
                    
                    captionView = customPopup(frame: CGRect(x: xPosition, y: sender.frame.origin.y-popupHeight, width: popupWidth, height: popupHeight))
                }
                else
                {
                    captionView = customPopup(frame: CGRect(x: sender.frame.origin.x-((popupWidth / 2) - (sender.frame.size.width / 2)), y: sender.frame.origin.y-popupHeight, width: popupWidth, height: popupHeight))
                }
                
                   
//                }
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    let offsetSize = captionView.frame.origin.x * currentZoomScale
                    
                    let imgWidth = scrollView.contentSize.width * currentZoomScale
                    
                    if offsetSize < imgWidth
                    {
                        scrollView.setContentOffset(CGPoint(x: captionView.frame.origin.x * currentZoomScale, y: scrollView.contentOffset.y), animated: true)
                    }
                    else
                    {
                        scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width * currentZoomScale, y: scrollView.contentOffset.y), animated: true)
                    }

                }
                captionView.caption = filterArray![0].heading
                captionView.desc = filterArray![0].description
                captionView.deal = filterArray![0].deal
                captionView.btnKnowMore.tag = sender.tag
                captionView.btnKnowMore.addTarget(self, action: #selector(actionKnowMore), for: .touchUpInside)
                do{
                     if (sender.tag == 2 || sender.tag == 8) //&& UIDevice.current.userInterfaceIdiom == .phone
                     {
                        documentsURL.appendPathComponent("popup_background_right.png")
                    }
                    else if sender.tag == 10
                    {
                        documentsURL.appendPathComponent("popup_background_right.png")
                    }
                    else
                    {
                        documentsURL.appendPathComponent("popup_background_centre.png")
                    }
                    //let imageURL = URL(fileURLWithPath: documentsURL.absoluteString)
                    let image = UIImage(data: try Foundation.Data(contentsOf: documentsURL))
                    
                    if sender.tag == 1 || sender.tag == 9 || sender.tag == 10 || sender.tag == 11 {
                        
                        if sender.tag == 10
                        {
                            captionView.background = image
                            captionView.imgBG.transform = CGAffineTransform(scaleX: 1, y: -1)
                            captionView.moveControlsDown(isMoveX: false)
                        }
                        else
                        {
                            captionView.background = image!.rotate(radians: .pi) //image
                            captionView.moveControlsDown(isMoveX: true)
                        }
                        
                        
                    }
                    else
                    {
                        captionView.background = image
                    }
                    
                }catch{ print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")}
                
                var iocnsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                iocnsURL = iocnsURL.appendingPathComponent("Tungi_Popup_Images")
                
                if sender.tag == 1 {
                    iocnsURL.appendPathComponent("Svaastha_Spa.jpg")
                }else if sender.tag == 2 {
                    iocnsURL.appendPathComponent("Amara_Bar.jpg")
                }else if sender.tag == 3 {
                    iocnsURL.appendPathComponent("Ripples.jpg")
                }else if sender.tag == 4 {
                    iocnsURL.appendPathComponent("Happy_Hub.jpg")
                }else if sender.tag == 5 {
                    iocnsURL.appendPathComponent("Pool_Area.jpg")
                }else if sender.tag == 6 {
                    iocnsURL.appendPathComponent("Lawn_Area.jpg")
                }else if sender.tag == 7 {
                    iocnsURL.appendPathComponent("Lobby.jpg")
                }else if sender.tag == 8 {
                    iocnsURL.appendPathComponent("Banquet.jpg")
                }else if sender.tag == 9 {
                    iocnsURL.appendPathComponent("Cafe_Laughing_Dove.jpg")
                }else if sender.tag == 10 {
                    iocnsURL.appendPathComponent("Gym.jpg")
                }else if sender.tag == 11 {
                    iocnsURL.appendPathComponent("Beauty_Salon.jpg")
                }
                
                //let iconPath = URL(fileURLWithPath: iocnsURL.absoluteString)
                do{
                    let image = UIImage(data: try Foundation.Data(contentsOf: iocnsURL))
                    captionView.icon = image
                }catch{ print("Error while enumerating files \(iocnsURL.path): \(error.localizedDescription)")}
        
               
                
                imageView.addSubview(captionView)
                
                var transform =  CGAffineTransform.identity
                transform = transform.scaledBy(x: 1.0/self.currentZoomScale, y: 1.0/self.currentZoomScale) //CGAffineTransform(scaleX: 1.0/self.currentZoomScale, y: 1.0/self.currentZoomScale)
                transform = transform.translatedBy(x: 0, y: 0)
                
                self.captionView.transform = transform
                
                var yPosition = sender.frame.origin.y - self.captionView.frame.size.height
                
                if senderAction!.tag == 1 || senderAction!.tag == 9 || senderAction!.tag == 10 || senderAction!.tag == 11 {
                    
                    yPosition = senderAction!.frame.origin.y + senderAction!.frame.size.height
                }
                
                captionView.frame = CGRect(x: self.captionView.frame.origin.x, y: yPosition, width: self.captionView.frame.size.width, height: self.captionView.frame.size.height)
                
                if (sender.tag == 2 || sender.tag == 8) //&& UIDevice.current.userInterfaceIdiom == .phone
                {
                    let xPosition = (sender.frame.origin.x + sender.frame.size.width) - self.captionView.frame.size.width
                    
                    captionView.frame = CGRect(x: xPosition, y: yPosition, width: self.captionView.frame.size.width, height: self.captionView.frame.size.height)
                }
                if sender.tag == 10
                {
                    let xPosition = (senderAction!.frame.origin.x + senderAction!.frame.size.width) - self.captionView.frame.size.width
                    
                     captionView.frame = CGRect(x: xPosition, y: yPosition, width: self.captionView.frame.size.width, height: self.captionView.frame.size.height)
                }
            }
        }
    }
    
    
    
    @objc func imageTapped(sender: UIButton){
        if captionView != nil {
            captionView.removeFromSuperview()
        }
    }
    
    @objc func actionKnowMore(sender: UIButton){
        MapViewVC.delegate?.actionMore(pivotID: sender.tag)
    }
}

