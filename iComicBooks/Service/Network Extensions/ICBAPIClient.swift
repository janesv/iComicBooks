//
//  ICBAPIClient.swift
//  iComicBooks
//
//  Created by Sviridova Evgenia on on 02/12/2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation
import UIKit

/**
    ICBAPIClient is a class for a xxcd API client implementation.
*/

let ICBAPIClientBaseURLString = "https://xkcd.com"

enum ICBComicError: Error {
    case noData
}

enum ICBComicResult {
    case result(ICBComic)
    case error(Error)
}

class ICBAPIClient {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    /**
     Get data from the API Client with additional parameters.
     - parameter comicId: comic id. If it's empty, this very comic is the last one.
     */
    func get(comicId: String, completionHandler: @escaping (ICBComicResult) -> ()) {
        let url = URL(string: "\(ICBAPIClientBaseURLString)\(comicId)/info.0.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completionHandler(.error(error!))
                return
            }
            
            guard let urlContent = data else {
                completionHandler(.error(ICBComicError.noData))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let comicObject = try jsonDecoder.decode(ICBComic.self, from: urlContent)
                completionHandler(.result(comicObject))
            } catch let jsonError as NSError {
                completionHandler(.error(jsonError))
            }
        }
        
        task.resume()
    }
}

//    func get(comicId: String, callback: @escaping completeClosure ) {
//        let url = URL(string: "\(ICBAPIClientBaseURLString)\(comicId)/info.0.json")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        let task = session.dataTask(with: request) { (data, response, error) in
//            //callback(data, error)
//            guard error == nil else {
//                callback(nil, error)
//                return
//            }
//
//            guard let urlContent = data else {
//                callback(nil, error)
//                return
//            }
//
//            callback(urlContent, nil)
//        }
//
//        task.resume()
//    }
