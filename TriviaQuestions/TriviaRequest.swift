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
    static let query = URLQueryItem(name: "amount", value: "10")
}
