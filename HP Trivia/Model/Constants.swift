//
//  Constants.swift
//  HP Trivia
//
//  Created by Apple on 25/04/24.
//

import Foundation

struct Constants {
    static let hpFont = "PartyLetPlain"
    
    static let previewQuestion = try! JSONDecoder().decode([Question].self, from: Data(contentsOf: Bundle.main.url(forResource: "trivia", withExtension: "json")!))[0]
}
