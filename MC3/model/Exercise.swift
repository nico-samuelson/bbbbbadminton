//
//  Exercise.swift
//  MC3
//
//  Created by Nico Samuelson on 23/07/24.
//

import Foundation
import SwiftData

@Model
class Exercise {
    var id: UUID = UUID.init()
    var date: Date = Date.now
    var duration: Double = 0
    var reps: Int = 0
    var accuracy: Double = 0
    var mistakes: [String] = []
    var fullRecord: String = ""
    
    init() {}
    
    init(id: UUID, date: Date, duration: Double, reps: Int, accuracy: Double, mistakes: [String], fullRecord: String) {
        self.id = id
        self.date = date
        self.duration = duration
        self.reps = reps
        self.accuracy = accuracy
        self.mistakes = mistakes
        self.fullRecord = fullRecord
    }
}