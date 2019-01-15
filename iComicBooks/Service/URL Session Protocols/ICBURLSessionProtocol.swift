//
//  ICBURLSessionProtocol.swift
//  iComicBooks
//
//  Created by Evgenia Sviridova on 16/12/2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}
