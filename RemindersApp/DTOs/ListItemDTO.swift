//
//  ListItemDTO.swift
//  RemindersApp
//
//  Copyright © 2021 semra. All rights reserved.
//

import Foundation

struct ListItemDTO {
    let id : String;
    let name: String;
    let colorCode: Int;
    let listImage: String;
    
    init (name: String, colorCode: Int, listImage: String){
        self.name = name;
        self.colorCode = colorCode;
        self.listImage = listImage;
        self.id = UUID().uuidString
    }
}
