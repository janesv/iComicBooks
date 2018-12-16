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

let ICBAPIClientBaseURLString = "https://xkcd.com"

enum ICBComicError: Error {
    case noData
}

enum ICBComicResult {
    case result(ICBComic)
    case error(Error)
}

class ICBAPIClient {
    
    typealias completeClosure = ( _ data: Data?, _ error: Error?) -> Void
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        
    }
    
    func get(comicId: String, callback: @escaping completeClosure ) {
        let url = URL(string: "\(ICBAPIClientBaseURLString)\(comicId)/info.0.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            //callback(data, error)
            guard error == nil else {
                callback(nil, error)
                return
            }
            
            guard let urlContent = data else {
                callback(nil, error)
                return
            }
            
            callback(urlContent, nil)
        }
        
        task.resume()
    }
}
