//
//  TaskModel.swift
//  SmartList
//
//  Created by Zhiyuan Zhou on 11/26/23.
//

import Foundation

public struct TaskModel: Identifiable, Codable {
    public let id = UUID()
    
    public let title: String
    
    public let date: String
    
    public let startTime: String
    
    public let duration: String
    
    public let description: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case date
        
        case startTime = "start_time"
        case duration
        case description
    }
}

public struct TaskItem: Codable {
    public let taskItems: [TaskModel]
    
    enum CodingKeys: String, CodingKey {
        case taskItems = "task_items"
    }
}
