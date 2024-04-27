//
//  FileManager+Ext.swift
//  HP Trivia
//
//  Created by Apple on 27/04/24.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }
}
