//
//  ListViewController.swift
//  RemindersApp
//
//  Copyright © 2021 semra. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    let colorArray = [ 0x000000, 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xfcff00, 0xd2ff00, 0x05c000, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0]
    let listTypes = ["list.bullet", "smiley.fill", "tag","flame.fill","doc.text.fill","bookmark.fill"];
    var selectedIndexPath : IndexPath!

    @IBOutlet weak var colorViewController: UICollectionView!
    
    @IBOutlet weak var listTypeViewController: UICollectionView!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    weak var listViewDelegate: ListUpdateControllerDelagate?
    
    @IBOutlet weak var listNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        colorViewController.delegate = self;
        colorViewController.dataSource = self;
        listTypeViewController.delegate = self;
        listTypeViewController.dataSource = self;
        doneButton.isEnabled = false;
        listNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
        for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (text.count > 0 && !doneButton.isEnabled){
            doneButton.isEnabled = true;
        }
        else if( text.count <= 0 && doneButton.isEnabled){
            doneButton.isEnabled = false;
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
         dismiss(animated: true, completion: nil);
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        let name = listNameTextField.text!;
        let colorIndex = colorViewController.indexPathsForSelectedItems?.first?.row ?? 0
        let listTypeIndex = listTypeViewController.indexPathsForSelectedItems?.first?.row ?? 0
        let listItem = ListItem(name: name, colorCode: colorArray[colorIndex] , listImage: listTypes[listTypeIndex]);
        listViewDelegate?.addNewList(listItem: listItem)
        dismiss(animated: true, completion: nil);
        
    }
    
    


}
extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == colorViewController) {
            return colorArray.count
        }
        return listTypes.count;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if (collectionView == colorViewController) {
            let cell = colorViewController.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorViewCell;
            let backgroundColor =  uiColorFromHex(rgbValue: colorArray[Int(indexPath.row)])
            cell.configure(image: backgroundColor);
            return cell;
        }
        let cell = listTypeViewController.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListTypeCell;
            let imageName = listTypes[indexPath.row]
        cell.configure(imageName: imageName);
            return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 3
            cell.layer.cornerRadius = cell.layer.frame.height/2
            cell.clipsToBounds = true
            cell.isSelected = true
        }
      
        
    }


    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.layer.borderWidth = 1
        cell?.layer.cornerRadius = 0
        cell?.isSelected = false
    }
    
    
    
}
