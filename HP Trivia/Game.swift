//
//  Game.swift
//  HP Trivia
//
//  Created by Apple on 26/04/24.
//

import SwiftUI

@MainActor
class Game: ObservableObject {
    @Published var gameScore = 0
    @Published var questionScore = 0
    @Published var recentScores = [0, 0, 0]
    
    private var allQuestions: [Question] = []
    private var answeredQuestions: [Int] = []
    private var savePath = FileManager.documentsDirectory.appending(path: "SavedScores")
    
    var filteredQuestions: [Question] = []
    var currentQuestion = Constants.previewQuestion
    var answers: [String] = []
    
    var currentAnswer: String {
        currentQuestion.answers.first { $0.value == true }!.key
    }
    
    init() {
        self.decodeQuestions()
    }
    
    func startGame() {
        gameScore = 0
        questionScore = 5
        answeredQuestions = []
    }
    
    func endGame() {
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores[0]
        recentScores[0] = gameScore
        
        saveScores()
    }
    
    func filterQuestions(to books: [Int]) {
        self.filteredQuestions = self.allQuestions.filter { books.contains($0.book) }
    }
    
    func newQuestion() {
        guard !filteredQuestions.isEmpty else { return }
        
        if answeredQuestions.count == filteredQuestions.count {
            answeredQuestions = []
        }
            
        var potentialQuestion = self.filteredQuestions.randomElement()!
        while answeredQuestions.contains(potentialQuestion.id) {
            potentialQuestion = self.filteredQuestions.randomElement()!
        }
        currentQuestion = potentialQuestion
        
        answers = []
        for answer in currentQuestion.answers.keys {
            answers.append(answer)
        }
        
        answers.shuffle()
        
        questionScore = 5
    }
    
    func correct() {
        answeredQuestions.append(currentQuestion.id)
        
        withAnimation {
            gameScore += questionScore
        }
    }
    
    func loadScores() {
        do {
            let data = try Data(contentsOf: savePath)
            recentScores = try JSONDecoder().decode([Int].self, from: data)
        } catch {
            recentScores = [0, 0, 0]
        }
    }
    
    private func saveScores() {
        do {
            let data = try JSONEncoder().encode(recentScores)
            try data.write(to: savePath)
        } catch {
            print("Unable to save data: \(error)")
        }
    }
    
    private func decodeQuestions() {
        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json") {
            do {
                let data =  try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.allQuestions = try decoder.decode([Question].self, from: data)
                self.filteredQuestions = self.allQuestions
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }
    }
}
