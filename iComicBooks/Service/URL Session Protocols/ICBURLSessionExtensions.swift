//
//  ICBURLSessionExtensions.swift
//  iComicBooks
//
//  Created by Evgenia Sviridova on 16/12/2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation

//MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
