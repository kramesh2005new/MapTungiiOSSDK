//
//  AssetsApiModel.swift
//  Mapconfig
//
//  Created by Arunkumar Porchezhiyan on 31/07/20.
//  Copyright © 2020 zvky. All rights reserved.
//

import UIKit
import Foundation


final class AssetsApiModel {
    
    private let apiClient: APIClient!
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getAssetsWebservice(parent: AnyObject, resort:Int, _ completion: @escaping ((Result<AssestsModel>) -> Void)) {
        let parentViewController = parent as? ParentViewController
        parentViewController?.startAnimate()
        var request = URLRequest(url: URL(string: URL_ASSESTS)!)
        request.httpMethod = "POST"
        let params = ["resort_id" : resort]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        apiClient.load(request) { (result) in
            switch result {
            case .success(let data):
                do {
                    let items = try JSONDecoder().decode(AssestsModel.self, from: data)
                    parentViewController?.stopAnimate()
                    completion(.success(items))
                } catch {
                    parentViewController?.stopAnimate()
                    completion(.failure(error))
                }
            case .failure(let error):
                parentViewController?.stopAnimate()
                completion(.failure(error))
            }
        }
    }
    
    func getPivotWebservice(parent: AnyObject, resort:Int, _ completion: @escaping ((Result<PivotModel>) -> Void)) {
        var request = URLRequest(url: URL(string: URL_PIVOT_POINTS)!)
        request.httpMethod = "POST"
        let params = ["resort_id" : resort]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        apiClient.load(request) { (result) in
            switch result {
            case .success(let data):
                do {
                    let items = try JSONDecoder().decode(PivotModel.self, from: data)
                    completion(.success(items))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func downloadAssets(parent: AnyObject, from: String, downloadURL: URLRequest, _ completion: @escaping ((Result<URL>) -> Void)) {
        let parentViewController = parent as? ParentViewController
        parentViewController?.startAnimate()
        
        apiClient.download(downloadURL) { (result) in
            switch result {
            case .success(let data):
                if from != "Static" {
                    parentViewController?.stopAnimate()
                }
                completion(.success(data))
            case .failure(let error):
                parentViewController?.stopAnimate()
                completion(.failure(error))
            }
        }
    }
    
}

