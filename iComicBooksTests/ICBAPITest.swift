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
    
    enum ThrownError: Error {
        case unxpectedError
    }
    
    let jsonObject = ["month": "12", "num": 2085, "link": "", "year": "2018", "news": "", "safe_title": "arXiv", "transcript": "", "alt": "Both arXiv and archive.org are invaluable projects which, if they didn't exist, we would dismiss as obviously ridiculous and unworkable.", "img": "https://imgs.xkcd.com/comics/arxiv.png", "title": "arXiv", "day": "14"] as [String : Any]
    
    let jsonObjectWithError = ["num": 2085, "link": "", "year": "2018", "news": "", "safe_title": "arXiv", "transcript": "", "alt": "Both arXiv and archive.org are invaluable projects which, if they didn't exist, we would dismiss as obviously ridiculous and unworkable.", "img": "https://imgs.xkcd.com/comics/arxiv.png", "title": "arXiv", "day": "14"] as [String : Any]
    
    var apiClient: ICBAPIClient!
    var comicId: String?
    let mockSession = MockURLSession()
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
        
    }
    
    func test_get_request_with_comic_id() {
        comicId = "/2085"
        apiClient = ICBAPIClient(session: mockSession)
        
        guard let comicId = comicId else {
            fatalError("ERROR: comic id can't be empty")
        }
        
        apiClient.get(comicId: comicId) { (response) in
            // Return data
        }
        
        XCTAssert(mockSession.lastURL == URL(string: "https://xkcd.com/2085/info.0.json"))
        
    }
    
    func test_get_request_with_empty_comic_id() {
        let emptyComicId = ""
        apiClient = ICBAPIClient(session: mockSession)
        
        apiClient.get(comicId: emptyComicId) { (response) in
            // Return data
        }
        
        XCTAssert(mockSession.lastURL == URL(string: "https://xkcd.com/info.0.json"))
        
    }
    
    func test_get_resume_called() {
        comicId = "/2085"
        apiClient = ICBAPIClient(session: mockSession)
        
        guard let comicId = comicId else {
            fatalError("ERROR: comic id can't be empty")
        }
        
        let dataTask = MockURLSessionDataTask()
        mockSession.nextDataTask = dataTask
        
        apiClient.get(comicId: comicId) { (response) in
            // Return data
        }
        
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func test_should_return_data() {
        comicId = "/2085"
        apiClient = ICBAPIClient(session: mockSession)
        
        guard let comicId = comicId else {
            fatalError("ERROR: comic id can't be empty")
        }
        
        apiClient.get(comicId: comicId) { (response) in
            switch response {
            case let .result(response):
               XCTAssertNotNil(response)
            default:
                return
            }
        }
    }
    
    func test_should_return_no_data_error() {
        comicId = "/0"

        apiClient = ICBAPIClient(session: mockSession)
        
        guard let comicId = comicId else {
            fatalError("ERROR: comic id can't be empty")
        }
        
        apiClient.get(comicId: comicId) { (response) in
            switch response {
            case let .error(response):
                XCTAssertEqual(response.localizedDescription, ICBComicError.noData.localizedDescription)
            default:
                return
            }
        }
    }
    
    func test_should_return_json_error() {
        comicId = "/2085"
        
        apiClient = ICBAPIClient(session: mockSession)
        
        guard let comicId = comicId else {
            fatalError("ERROR: comic id can't be empty")
        }
        
        let expectedDataWithError = jsonToData(json: jsonObjectWithError as AnyObject)
        mockSession.nextData = expectedDataWithError
        
        apiClient.get(comicId: comicId) { (response) in
            switch response {
            case let .error(response):
                XCTAssertNotNil(response.localizedDescription)
            default:
                return
            }
        }
    }
    
    func test_should_return_error() {
        comicId = "/2085"
        
        apiClient = ICBAPIClient(session: mockSession)
        
        guard let comicId = comicId else {
            fatalError("ERROR: comic id can't be empty")
        }
        
        let expectedData = jsonToData(json: jsonObject as AnyObject)
        mockSession.nextData = expectedData
        mockSession.nextError = ThrownError.unxpectedError
        
        apiClient.get(comicId: comicId) { (response) in
            switch response {
            case let .error(response):
                XCTAssertNotNil(response.localizedDescription)
            default:
                return
            }
        }
    }
    
    func test_check_data() {
        comicId = "/2085"
        apiClient = ICBAPIClient(session: mockSession)
        
        guard let comicId = comicId else {
            fatalError("ERROR: comic id can't be empty")
        }
        
        let expectedData = jsonToData(json: jsonObject as AnyObject)
        mockSession.nextData = expectedData
        
        apiClient.get(comicId: comicId) { (response) in
            switch response {
            case let .result(response):
                XCTAssertEqual(response.month, "12")
                XCTAssertEqual(response.num, 2085)
                XCTAssertEqual(response.link, "")
                XCTAssertEqual(response.year, "2018")
                XCTAssertEqual(response.news, "")
                XCTAssertEqual(response.safeTitle, "arXiv")
                XCTAssertEqual(response.transcript, "")
                XCTAssertEqual(response.alt, "Both arXiv and archive.org are invaluable projects which, if they didn't exist, we would dismiss as obviously ridiculous and unworkable.")
                XCTAssertEqual(response.img, "https://imgs.xkcd.com/comics/arxiv.png")
                XCTAssertEqual(response.title, "arXiv")
                XCTAssertEqual(response.day, "14")
            default:
                return
            }
        }
    }
}
