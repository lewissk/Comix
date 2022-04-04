//
//  MarvelModelTests.swift
//  ComixTests
//
//  Created by Scott Lewis on 4/4/22.
//

import XCTest

class MarvelModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMarvelRequestControllerParse() throws {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "marvel-test", withExtension: "json") else {
            XCTFail("Missing file: marvel-test.json")
            return
        }
        
        let json = try Data(contentsOf: url)
        
        let rc = MarvelRequestController()
        let comicsResult = rc.parse(json)
        let unwrappedResult = try XCTUnwrap(comicsResult)
        
        XCTAssertEqual(unwrappedResult.code, 200)
        XCTAssertEqual(unwrappedResult.status, "Ok")
        XCTAssertEqual(unwrappedResult.copyright, "© 2022 MARVEL")
        XCTAssertEqual(unwrappedResult.attributionText, "Data provided by Marvel. © 2022 MARVEL")
        XCTAssertEqual(unwrappedResult.attributionHTML, "<a href=\"http://marvel.com\">Data provided by Marvel. © 2022 MARVEL</a>")
        XCTAssertEqual(unwrappedResult.etag, "ab1ec9d2bcdaf5188da254f23cbc0b6c185a7969")
        XCTAssertEqual(unwrappedResult.data.offset, 0)
        XCTAssertEqual(unwrappedResult.data.limit, 1)
        XCTAssertEqual(unwrappedResult.data.total, 51580)
        XCTAssertEqual(unwrappedResult.data.count, 1)
        XCTAssertEqual(unwrappedResult.data.results.count, 1)
        let uItem = try XCTUnwrap(unwrappedResult.data.results.first)
        XCTAssertEqual(uItem.id, 82967)
        XCTAssertEqual(uItem.digitalId, 0)
        XCTAssertEqual(uItem.title, "Marvel Previews (2017)")
        XCTAssertEqual(uItem.issueNumber, 0)
        XCTAssertEqual(uItem.variantDescription, "Some descr")
        XCTAssertNil(uItem.description)
        XCTAssertEqual(uItem.modified, "2019-11-07T08:46:15-0500")
        XCTAssertEqual(uItem.isbn, "")
        XCTAssertEqual(uItem.upc, "75960608839302811")
        XCTAssertEqual(uItem.diamondCode, "")
        XCTAssertEqual(uItem.ean, "")
        XCTAssertEqual(uItem.issn, "")
        XCTAssertEqual(uItem.format, "")
        XCTAssertEqual(uItem.pageCount, 112)
        XCTAssertEqual(uItem.thumbnail.path, "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available")
        XCTAssertEqual(uItem.thumbnail.fileExtension, "jpg")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
