//
//  TriviaAPIResponse.swift
//  TriviaQuestions
//
//  Created by Chris Eadie on 26/11/2020.
//

import Foundation

// CREDIT: Basic structs provided by 'Paste JSON as Code' macOS app and then adjusted

// MARK: - TriviaAPIResponse
struct TriviaAPIResponse: Codable {
    let responseCode: Int
    let triviaItems: [TriviaItem]

    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case triviaItems = "results"
    }
}

// MARK: - Result
struct TriviaItem: Codable {
    let category: String
    let type: TypeEnum
    let difficulty: Difficulty
    let question, correctAnswer: String
    let incorrectAnswers: [String]

    enum CodingKeys: String, CodingKey {
        case category, type, difficulty, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

enum Difficulty: String, Codable {
    case easy, hard, medium
//    case easy = "easy"
//    case hard = "hard"
//    case medium = "medium"
}

enum TypeEnum: String, Codable {
    case boolean, multiple
//    case boolean = "boolean"
//    case multiple = "multiple"
}
