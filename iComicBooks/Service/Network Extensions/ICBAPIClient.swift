//
//  ICBAPIClient.swift
//  iComicBooks
//
//  Created by Sviridova Evgenia on 19.07.2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation
import UIKit

/**
    ICBAPIClient is a class for a xxcd API client implementation.
*/

fileprivate let ICBAPIClientBaseURLString = "https://xkcd.com"

enum ICBComicError: Error {
    case noData
}

enum ICBComicResult {
    case result(ICBComic)
    case error(Error)
}

class ICBAPIClient {
    private var baseURL: URL
    
    private static var sharedAPIClient: ICBAPIClient = {
        let url = URL(string: ICBAPIClientBaseURLString)!
        let sharedInstance = ICBAPIClient(baseURL: url)
        return sharedInstance
    }()
    
    
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    class func shared() -> ICBAPIClient {
        return sharedAPIClient
    }
    
    
    /**
        Get data from the API Client with additional parameters.
        - parameter comicId: comic id. If it's empty, this very comic is the last one.
     */
    func getDataFrom(withParameters comicId: String, completionHandler: @escaping (ICBComicResult) -> ()) {
        self.baseURL = URL(string: "\(ICBAPIClientBaseURLString)\(comicId)/info.0.json")!
        self.baseURL.make(completionHandler: completionHandler)
    }
}

fileprivate extension URL {
    func make(completionHandler: @escaping (ICBComicResult) -> ()) {
        let url = self
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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




