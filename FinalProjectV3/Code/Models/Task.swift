//
//  Task.swift
//  FinalProjectV3
//
//  Created by Thanawat Sriwanlop on 6/11/2565 BE.
//

import Foundation

struct TaskType {
    let symbolName: String
    let typeName: String
}

struct Task {
    var taskName: String
    var taskDescription: String
    var seconds: Int
    var taskType: TaskType
    
    var timeStamp: Double
}

enum CountdownState {
    case suspended
    case running
    case paused
}

