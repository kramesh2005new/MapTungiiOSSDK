//
//  Manager.swift
//  MapSDK
//
//  Created by Arunkumar Porchezhiyan on 06/08/20.
//  Copyright © 2020 zvky. All rights reserved.
//

import UIKit

public class Manager {
    public init(){}
    
    public func viewController() -> UIViewController {
        //let bundle = Bundle(for: MapViewVC.self)
        let VC = MapViewVC()
        //let vc = MapViewVC(nibName: "MapViewVC", bundle: bundle)
        return VC
    }
}
