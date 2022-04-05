//
//  MarvelModel.swift
//  Comix
//
//  Created by Scott Lewis on 4/2/22.
//

import Foundation

struct MarvelComicResultsHeader: Codable {
    var code: Int
    var status: String
    var copyright: String
    var attributionText: String
    var attributionHTML: String
    var etag: String
    var data: MarvelComicData
}

struct MarvelComicData: Codable {
    var offset: Int
    var limit: Int
    var total: Int
    var count: Int
    var results: [MarvelComicResult]
}

struct MarvelComicResult: Codable, Identifiable {
    var id: Int
    var digitalId: Int
    var title: String
    var issueNumber: Int
    var variantDescription: String
    var description: String?
    var modified: String
    var isbn: String
    var upc: String
    var diamondCode: String
    var ean: String
    var issn: String
    var format: String
    var pageCount: Int
    var textObjects: [MarvelTextObject]
    var resourceURI: String
    var urls: [MarvelURL]
    var series: MarvelResource
    var variants: [MarvelResource]
//    var collections: []
//    var collectionIssues: []
//    var dates: [] "dates":[{"type":"onsaleDate","date":"2099-10-30T00:00:00-0500"},],
//    var prices: [] "prices":[{"type":"printPrice","price":0}],
    var thumbnail: MarvelImage
    var images: [MarvelImage]?
    var creators: MarvelCreators
    var characters: MarvelCharacters //{"available":0,"collectionURI":"http://gateway.marvel.com/v1/public/comics/82967/characters","items":[],"returned":0},
//    "events":{"available":0,"collectionURI":"http://gateway.marvel.com/v1/public/comics/82967/events","items":[],"returned":0}
}

struct MarvelStory: Codable {
    var resourceURI: String
    var name: String
    var type: String
}

struct MarvelStories: Codable {
    var available: Int
    var collectionURI: String
    var items: [MarvelStory]
    var returned: Int
}

struct MarvelCharacters: Codable {
    var available: Int
    var collectionURI: String
    var items: [MarvelResource]
}

struct MarvelTextObject: Codable, Hashable {
    var type: String
    var language: String
    var text: String
}

struct MarvelCreator: Codable, Hashable {
    var resourceURI: String
    var name: String
    var role: String
}

struct MarvelCreators: Codable {
    var available: Int
    var collectionURI: String
    var items: [MarvelCreator]?
    var returned: Int
}

struct MarvelResource: Codable, Hashable {
    var resourceURI: String
    var name: String
}

struct MarvelURL: Codable {
    var type: String
    var url: String
}

struct MarvelImage: Codable {
    enum CodingKeys: String, CodingKey {
        case path, resourceURI
        case fileExtension = "extension"
    }
    var path: String
    var fileExtension: String
    var resourceURI: String?
    
    func imageURL(size: MarvelImageSize) -> URL? {
        let imageURLText = "\(path)/\(size.rawValue).\(fileExtension)"
        let secureImageURLText = imageURLText.replacingOccurrences(of: "http://", with: "https://")
        let url = URL(string: secureImageURLText)
        return url
    }
}

enum MarvelImageSize: String {
    case portraitSmall = "portrait_small"
    case portraitMedium = "portrait_medium"
    case portraitXLarge = "portrait_xlarge"
    case portraitFantastic = "portrait_fantastic"
    case portraitUncanny = "portrait_uncanny"
    case portraitIncredible = "portrait_incredible"
    case standardSmall = "standard_small"
    case standardMedium = "standard_medium"
    case standardLarge = "standard_large"
    case standardXLarge = "standard_xlarge"
    case standardFantastic = "standard_fantastic"
    case standardAmazing = "standard_amazing"
    case landscapeSmall = "landscape_small"
    case landscapeMedium = "landscape_medium"
    case landscapeLarge = "landscape_large"
    case landscapeXLarge = "landscape_xlarge"
    case landscapeAmazing = "landscape_amazing"
    case landscapeIncredible = "landscape_incredible"
    
}
