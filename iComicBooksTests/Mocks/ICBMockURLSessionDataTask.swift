//
//  ICBMockURLSessionDataTask.swift
//  iComicBooksTests
//
//  Created by Evgenia Sviridova on 16/12/2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation
@testable import iComicBooks

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
