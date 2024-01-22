//
//  TaskViewModel.swift
//  FinalProjectV3
//
//  Created by Thanawat Sriwanlop on 6/11/2565 BE.
//

import Foundation

class TaskViewModel {
    
    // MARK: - variables
    private var task: Task!
    
    private let taskTypes: [TaskType] = [
        TaskType(symbolName: "star", typeName: "Priority"),
        TaskType(symbolName: "iphone", typeName: "Develop"),
        TaskType(symbolName: "gamecontroller", typeName: "Gaming"),
        TaskType(symbolName: "film", typeName: "Movie"),
        TaskType(symbolName: "wand.and.stars.inverse", typeName: "Editing"),
        TaskType(symbolName: "books.vertical", typeName: "Reading"),
        TaskType(symbolName: "trash", typeName: "Clean Up"),
        TaskType(symbolName: "backpack", typeName: "Packing"),
        TaskType(symbolName: "person.2", typeName: "Outdoor"),
        TaskType(symbolName: "sportscourt", typeName: "Football"),
        TaskType(symbolName: "basketball", typeName: "Basketball"),
        TaskType(symbolName: "tennis.racket", typeName: "Tennis"),
        TaskType(symbolName: "moon.zzz", typeName: "Sleep"),
        TaskType(symbolName: "scissors", typeName: "Sewing"),
        TaskType(symbolName: "dumbbell", typeName: "Workout"),
        TaskType(symbolName: "dice", typeName: "Betting"),
        TaskType(symbolName: "pianokeys", typeName: "Piano"),
        TaskType(symbolName: "shower", typeName: "Showering"),
        TaskType(symbolName: "party.popper", typeName: "Party"),
        TaskType(symbolName: "frying.pan", typeName: "Cooking"),
        TaskType(symbolName: "mountain.2", typeName: "Climbing"),
        TaskType(symbolName: "airplane", typeName: "Flying"),
        TaskType(symbolName: "graduationcap", typeName: "Studying"),
        TaskType(symbolName: "swift", typeName: "Swift"),
        TaskType(symbolName: "x.squareroot", typeName: "Math"),
        TaskType(symbolName: "camera", typeName: "Photoshoot"),
        TaskType(symbolName: "message", typeName: "Seminar"),
        TaskType(symbolName: "hammer", typeName: "Craft"),
        TaskType(symbolName: "tent", typeName: "Camping"),
        TaskType(symbolName: "radio", typeName: "Radio"),
        TaskType(symbolName: "cross", typeName: "Healthcare"),
        TaskType(symbolName: "character.cursor.ibeam", typeName: "English"),
        TaskType(symbolName: "character.cursor.ibeam.ja", typeName: "Japanese"),
        TaskType(symbolName: "fx", typeName: "Effect"),
        TaskType(symbolName: "wrench", typeName: "Fixing")
    ]
    
    private var selectedIndex = -1 {
        didSet {
            // set task type here
            self.task.taskType = self.getTaskType()[selectedIndex]
        }
    }
    
    private var hours = Box(0)
    private var minutes = Box(0)
    private var seconds = Box(0)
    
    
    // MARK: - init
    init() {
        task = Task(taskName: "", taskDescription: "", seconds: 0, taskType: .init(symbolName: "", typeName: ""), timeStamp: 0)
    }
    
    
    // MARK: - functions
    func setSelectecIndex(to value: Int) {
        self.selectedIndex = value
    }
    
    func setTaskName(to value: String) {
        self.task.taskName = value
    }
    
    func setTaskDescription(to value: String) {
        self.task.taskDescription = value
    }
    
    func getSelectedIndex() -> Int {
        self.selectedIndex
    }
    
    func getTask() -> Task {
        return self.task
    }
    
    func getTaskType() -> [TaskType] {
        return self.taskTypes
    }
    
    
    func setHours(to value: Int) {
        self.hours.value = value
    }
    
    func setMinutes(to value: Int) {
        var newMinutes = value
        
        if (value >= 60) {
            newMinutes -= 60
            hours.value += 1
        }
        
        self.minutes.value = newMinutes
    }
    
    func setSeconds(to value: Int) {
        var newSeconds = value
        
        if (value >= 60) {
            newSeconds -= 60
            minutes.value += 1
        }
        
        if (minutes.value >= 60) {
            minutes.value -= 60
            hours.value += 1
        }
        
        self.seconds.value = newSeconds
    }
    
    func getHours() -> Box<Int> {
        return self.hours
    }
    
    func getMinutes() -> Box<Int> {
        return self.minutes
    }
    
    func getSeconds() -> Box<Int> {
        return self.seconds
    }
    
    func computeSeconds() {
        self.task.seconds = (hours.value * 3600) + (minutes.value * 60) + seconds.value
        self.task.timeStamp = Date().timeIntervalSince1970
    }
    
    func isTaskValid() -> Bool {
        if (!task.taskName.isEmpty && !task.taskDescription.isEmpty && selectedIndex != 1 && (self.seconds.value > 0 || self.minutes.value > 0 || self.hours.value > 0)) {
            return true
        }
        return false
    }
}

