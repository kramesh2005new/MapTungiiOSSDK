//  ApiClient.swift
//  Mapconfig
//
//  Created by Arunkumar Porchezhiyan on 07/08/20.
//  Copyright © 2020 zvky. All rights reserved.
//
import Foundation

// TODO: - Move to the separated file GenericResult.swift
enum Result<T> {
    case success(T)
    case failure(Error)
}

enum APIClientError: Error {
    case noData
}

final class APIClient {
    
    func load(_ resource: URLRequest, result: @escaping ((Result<Foundation.Data>) -> Void)) {
        let task = URLSession.shared.dataTask(with: resource) { (data, response, error) in
            if let error = error {
                result(.failure(error))
              return
            }

            result(.success(data!))
        }
        task.resume()
    }
    
    func download(_ resource: URLRequest, result: @escaping ((Result<URL>) -> Void)) {
        let task = URLSession.shared.downloadTask(with: resource) { (URL, response, error) in
            guard URL != nil else {
                result(.failure(APIClientError.noData))
                return
            }
            if let error = error {
                result(.failure(error))
                return
            }
            result(.success(URL!))
        }
        task.resume()
    }
    
}
