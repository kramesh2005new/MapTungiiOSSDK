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
    @IBOutlet weak var lblCaption: VerticalAlignLabel!
    @IBOutlet weak var lbldescription: UILabel!
    @IBOutlet weak var lblDeal: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var btnKnowMore: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
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
    
    var isKnowMoreRequired : Bool {
        
        get { return btnKnowMore.isHidden }
        set { btnKnowMore.isHidden = newValue }
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
        lblCaption.verticalAlignment = .bottom
        
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL = documentsURL.appendingPathComponent("Static_BG/Popup")
        do{
            documentsURL.appendPathComponent("bg_knowmore.png")
            //let imageURL = URL(fileURLWithPath: documentsURL.absoluteString)
            let image = UIImage(data: try Foundation.Data(contentsOf: documentsURL))
            btnKnowMore.setBackgroundImage(image, for: .normal)
        }catch{ print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")}
    }
    
    @IBAction func actionKnow(_ sender: Any) {
        
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    func getDirectoryPath() -> URL
    {
        let documentDirectoryPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
        let pathWithFolderName = documentDirectoryPath.appendingPathComponent("map_assets")
        let url = URL(string: pathWithFolderName) // convert path in url
          
        return url!
    }
    
    func moveControlsDown(isMoveX : Bool)
    {
        var xMove : CGFloat = 0
        
        if isMoveX
        {
            xMove = 5
        }
        
        lblCaption.frame = CGRect(x: lblCaption.frame.origin.x, y: lblCaption.frame.origin.y + 25, width: lblCaption.frame.size.width, height: lblCaption.frame.size.height)
        lbldescription.frame = CGRect(x: lbldescription.frame.origin.x, y: lbldescription.frame.origin.y + 25, width: lbldescription.frame.size.width, height: lbldescription.frame.size.height)
        lblDeal.frame = CGRect(x: lblDeal.frame.origin.x, y: lblDeal.frame.origin.y + 25, width: lblDeal.frame.size.width, height: lblDeal.frame.size.height)
        imgIcon.frame = CGRect(x: imgIcon.frame.origin.x + xMove, y: imgIcon.frame.origin.y + 25, width: imgIcon.frame.size.width, height: imgIcon.frame.size.height)
        btnKnowMore.frame = CGRect(x: btnKnowMore.frame.origin.x, y: btnKnowMore.frame.origin.y + 25, width: btnKnowMore.frame.size.width, height: btnKnowMore.frame.size.height)
        
        btnClose.frame = CGRect(x: btnClose.frame.origin.x, y: btnClose.frame.origin.y + 25, width: btnClose.frame.size.width, height: btnClose.frame.size.height)
    }
}
