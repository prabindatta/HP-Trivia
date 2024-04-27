//
//  InfoBackgroundImage.swift
//  HP Trivia
//
//  Created by Apple on 25/04/24.
//

import SwiftUI

struct InfoBackgroundImage: View {
    var body: some View {
        Image("parchment")
            .resizable()
            .ignoresSafeArea()
            .background(.brown)
    }
}

#Preview {
    InfoBackgroundImage()
}
