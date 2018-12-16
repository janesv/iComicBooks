//
//  ICBAPITest.swift
//  iComicBooksTests
//
//  Created by Sviridova Evgenia on 02/12/2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import XCTest
@testable import iComicBooks

func jsonToData(json: AnyObject) -> Data? {
    do {
        return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as Data
    } catch let myJSONError {
        print(myJSONError)
    }
    return nil
}

class ICBAPIClientTests: XCTestCase {
    
    let jsonObject = ["month": "12", "num": 2085, "link": "", "year": "2018", "news": "", "safe_title": "arXiv", "transcript": "", "alt": "Both arXiv and archive.org are invaluable projects which, if they didn't exist, we would dismiss as obviously ridiculous and unworkable.", "img": "https://imgs.xkcd.com/comics/arxiv.png", "title": "arXiv", "day": "14"] as [String : Any]
    
    var apiClient: ICBAPIClient!
    var comicId: String?
    let mockSession = MockURLSession()
    
    override func setUp() {
        super.setUp()
        
        comicId = ""
        apiClient = ICBAPIClient(session: mockSession)
    }
    
    override func tearDown() {
        super.tearDown()
        
        comicId = nil
    }
    
    func test_get_request_with_comic_id() {
        
        guard let comicId = comicId else {
            fatalError("ERROR: comic id can't be empty")
        }
        
        apiClient.get(comicId: comicId) { (success, response) in
            // Return data
        }
        
        XCTAssert(mockSession.lastURL == URL(string: "https://xkcd.com/info.0.json"))
        
    }
    
    func test_get_resume_called() {
        guard let comicId = comicId else {
            fatalError("ERROR: comic id can't be empty")
        }
        
        let dataTask = MockURLSessionDataTask()
        mockSession.nextDataTask = dataTask
        
        apiClient.get(comicId: comicId) { (success, response) in
            // Return data
        }
        
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func test_get_should_return_data() {
        guard let comicId = comicId else {
            fatalError("ERROR: comic id can't be empty")
        }
        
        let expectedData = jsonToData(json: jsonObject as AnyObject)
        
        mockSession.nextData = expectedData
        
        var actualData: Data?
        apiClient.get(comicId: comicId) { (data, error) in
            actualData = data
        }
        
        XCTAssertNotNil(actualData)
    }
    
    func test_decode_data() {
        guard let comicId = comicId else {
            fatalError("ERROR: comic id can't be empty")
        }
        
        let expectedData = jsonToData(json: jsonObject as AnyObject)
        
        mockSession.nextData = expectedData
        
        apiClient.get(comicId: comicId) { (data, error) in
            guard error == nil else {
                fatalError("\(String(describing: error))")
            }
            
            guard let urlContent = data else {
                fatalError("\(String(describing: data))")
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let comicObject = try jsonDecoder.decode(ICBComic.self, from: urlContent)
                XCTAssertNotNil(comicObject, "Comic object is nil")
                XCTAssertEqual(comicObject.num, 2085)
            } catch let jsonError as NSError {
                fatalError("\(jsonError)")
            }
        }
    }
}
