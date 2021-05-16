//
//  ListViewCell.swift
//  RemindersApp
//
//

import UIKit

class ListViewCell: UITableViewCell {
    @IBOutlet weak var listTypeImage: UIImageView!
    
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var reminderCount: UILabel!
    
    func configure(name: String, imageName: String, imageColor: UIColor, reminderCount: Int){
        self.listName.text = name;
        self.listTypeImage.image = UIImage(systemName: imageName);
        self.listTypeImage.tintColor = imageColor
        self.reminderCount.text = String(reminderCount)
        
    }
}
