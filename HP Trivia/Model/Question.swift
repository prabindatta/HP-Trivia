//
//  Question.swift
//  HP Trivia
//
//  Created by Apple on 26/04/24.
//

import Foundation

struct Question: Codable {
    let id: Int
    let question: String
    var answers: [String: Bool] = [:]
    let book: Int
    let hint: String
    
    enum QuestionKeys: String, CodingKey {
        case id
        case question
        case answer
        case wrong
        case book
        case hint
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: QuestionKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.question = try container.decode(String.self, forKey: .question)
        self.book = try container.decode(Int.self, forKey: .book)
        self.hint = try container.decode(String.self, forKey: .hint)
        
        let correctAnswer = try container.decode(String.self, forKey: .answer)
        self.answers[correctAnswer] = true
        
        let wrongAnswers = try container.decode([String].self, forKey: .wrong)
        wrongAnswers.forEach { wrongAnswer in
            self.answers[wrongAnswer] = false
        }
    }
}
