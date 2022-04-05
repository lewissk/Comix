//
//  ComixTests.swift
//  ComixTests
//
//  Created by Scott Lewis on 4/2/22.
//

import XCTest
@testable import Comix

class ComixTests: XCTestCase {
    var sut: ComicsCollectionViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ComicsCollectionViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDateWithMilliseconds() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let someDateTime = formatter.date(from: "2016/10/08 22:31:00")
        assert(someDateTime?.millisecondsSince1970 == 1475987460000)
    }
    
    func testInitialDateWithMilliseconds() {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let someDateTime = formatter.date(from: "1970/01/01 00:00:00")
        assert(someDateTime?.millisecondsSince1970 == 0)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testVC() throws {
//        sut.collectionView(<#T##collectionView: UICollectionView##UICollectionView#>, heightForComicAtIndexPath: <#T##IndexPath#>)
    }

}
