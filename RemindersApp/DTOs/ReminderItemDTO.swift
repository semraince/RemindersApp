//
//  ReminderItemDTO.swift
//  RemindersApp
//
//  Copyright © 2021 semra. All rights reserved.
//

import Foundation

import Foundation

struct ReminderItemDTO {
    let id: String
    let title: String
    var notes: String
    var flag: Bool
    var priority: Int
    var status: Int
    let listItemId: String
    
    init(title: String, notes: String, flag: Bool, priority: Int, listItemId: String){
        self.listItemId = listItemId;
        self.id = UUID().uuidString;
        self.title = title
        self.notes = notes
        self.flag = flag;
        self.priority = priority;
        self.status = 0;
    }
    
}
