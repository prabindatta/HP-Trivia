//
//  DoneButton+Ext.swift
//  HP Trivia
//
//  Created by Apple on 25/04/24.
//

import SwiftUI

extension Button {
    func doneButton() -> some View {
        self
            .font(.largeTitle)
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(.brown)
            .foregroundColor(.white)
    }
}
