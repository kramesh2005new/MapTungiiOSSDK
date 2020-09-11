//
//  customPopup.swift
//  Mapconfig
//
//  Created by Arunkumar Porchezhiyan on 04/08/20.
//  Copyright © 2020 zvky. All rights reserved.
//

import UIKit

class customPopup: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var lbldescription: UILabel!
    @IBOutlet weak var lblDeal: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var btnKnowMore: UIButton!
    
    var caption: String? {
        get { return lblCaption?.text }
        set { lblCaption.text = newValue }
    }
    
    var desc: String? {
        get { return lbldescription?.text }
        set { lbldescription.text = newValue }
    }
    
    var deal: String? {
        get { return lblDeal?.text }
        set { lblDeal.text = newValue }
    }
    
    var content: String? {
        get { return lblDeal?.text }
        set { lblDeal.text = newValue }
    }
    
    var icon: UIImage? {
        get { return imgIcon?.image }
        set { imgIcon.image = newValue }
    }
    
    var background: UIImage? {
        get { return imgBG?.image }
        set { imgBG.image = newValue }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
                
        let bundle = Bundle(for: customPopup.self)
        bundle.loadNibNamed("customPopup", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        var documentsURL = self.getDirectoryPath()
        documentsURL = documentsURL.appendingPathComponent("static_assets_19/Static_BG/Popup")
        do{
            documentsURL.appendPathComponent("bg_knowmore.png")
            let imageURL = URL(fileURLWithPath: documentsURL.absoluteString)
            let image = UIImage(data: try Foundation.Data(contentsOf: imageURL))
            btnKnowMore.setBackgroundImage(image, for: .normal)
        }catch{ print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")}
    }
    
    @IBAction func actionKnow(_ sender: Any) {
        
    }
    
    func getDirectoryPath() -> URL
    {
        let documentDirectoryPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
        let pathWithFolderName = documentDirectoryPath.appendingPathComponent("map_assets")
        let url = URL(string: pathWithFolderName) // convert path in url
          
        return url!
    }
}
