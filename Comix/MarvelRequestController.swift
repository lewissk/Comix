//
//  MarvelRequestController.swift
//  Comix
//
//  Created by Scott Lewis on 4/2/22.
//

import Foundation
import CryptoKit

class MarvelRequestController {
    
    func fetchComics(offset: Int = 0, limit: Int = 50, completionHandler: @escaping (MarvelComicResultsHeader?) -> Void) {
        /* Configure session, choose between:
           * defaultSessionConfiguration
           * ephemeralSessionConfiguration
           * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        let sessionConfig = URLSessionConfiguration.default

        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        /* Create the Request:Request (2) (GET https://gateway.marvel.com:443/v1/public/characters) */
        guard var URL = URL(string: "https://gateway.marvel.com:443/v1/public/comics") else {return}
        let timestamp = Date().millisecondsSince1970
        let apiKey = "7ac09d0426360d1f376555086c7dd29b"
        let secretKey = "0373e5445b5b3814f62665dca4f0b5aceacaa9eb"
        let hash = MD5(string: "\(timestamp)\(secretKey)\(apiKey)")
        let URLParams = [
            "apikey": apiKey,
            "hash": hash,
            "ts": "\(timestamp)",
            "orderBy": "focDate",
            "limit": String(limit),
            "offset": String(offset)
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"

        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                
                guard let data = data else {
                    completionHandler(.none)
                    return
                }
                
                completionHandler(self.parse(data))
                
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    func parse(_ data: Data) -> MarvelComicResultsHeader? {
        do {
            let decoder = JSONDecoder()
            let comicsResult = try decoder.decode(MarvelComicResultsHeader.self, from: data)
            return comicsResult
        }
        catch {
            print(String(data: data, encoding: .utf8) ?? "Data was nil")
            print("ERROR:\n\(error)")
            return .none
        }
    }
}


protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
    */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
    */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}
