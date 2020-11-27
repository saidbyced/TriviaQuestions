//
//  TriviaRequest.swift
//  TriviaQuestions
//
//  Created by Chris Eadie on 26/11/2020.
//

import Foundation

enum TriviaError: Error {
    case dataNotProvided, dataNotParsed
}

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
    
    func getTrivia(completion: @escaping (Result<[TriviaItem], TriviaError>) -> Void) {
        let task = URLSession.shared.dataTask(with: basicURL) { (data, response, error) in
            guard let data = data else {
                completion(.failure(.dataNotProvided))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode(TriviaAPIResponse.self, from: data)
                let triviaItems = results.triviaItems
                completion(.success(triviaItems))
            } catch {
                completion(.failure(.dataNotParsed))
            }
        }
        
        task.resume()
    }
}
