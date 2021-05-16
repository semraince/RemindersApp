//
//  ListTypeCell.swift
//  RemindersApp
//
//

import UIKit

class ListTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var listTypeImage: UIImageView!
    
    func configure(imageName: String) {
        self.listTypeImage.image = UIImage(systemName: imageName);
    }
    
}
