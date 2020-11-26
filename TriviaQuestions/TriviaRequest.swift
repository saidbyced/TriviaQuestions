//
//  TriviaRequest.swift
//  TriviaQuestions
//
//  Created by Chris Eadie on 26/11/2020.
//

import Foundation

struct TriviaAPI {
    static let scheme = "https"
    static let host = "opentdb.com"
    static let path = "/api.php"
    static let amountQuery = URLQueryItem(name: "amount", value: "10")
}

struct TriviaRequest {
    var basicURL: URL
    
    init() {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = TriviaAPI.scheme
        urlComponents.host = TriviaAPI.host
        urlComponents.path = TriviaAPI.path
        urlComponents.queryItems = [TriviaAPI.amountQuery]
        
        guard let composedURL = urlComponents.url else {
            fatalError()
        }
        
        self.basicURL = composedURL
    }
}
