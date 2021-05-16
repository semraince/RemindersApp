//
//  ColorViewCell.swift
//  RemindersApp
//
//

import UIKit

class ColorViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var colorImage: UIView!
    
    @IBOutlet weak var outerView: UIView!
    
    func configure(image: UIColor){
        colorImage.backgroundColor = image;
        colorImage.layer.cornerRadius = min(colorImage.frame.size.height, colorImage.frame.size.width) / 2.0
        colorImage.clipsToBounds = true
    }
}


