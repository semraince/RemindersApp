//
//  ViewController.swift
//  RemindersApp
//
//  Copyright © 2021 semra. All rights reserved.
//

import UIKit

protocol ListUpdateControllerDelagate: class {
    func addNewList(listItem: ListItem);
}

protocol ReminderUpdateControllerDelegate: class {
    func getListItems() -> [ListItem];
    func addListItem(item: ReminderItem);
}

class ViewController: UIViewController, ListUpdateControllerDelagate, ReminderUpdateControllerDelegate {

   
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var flaggedView: UIView!
    @IBOutlet weak var listTable: UITableView!
    
    @IBOutlet weak var numberOfReminders: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var numberOfFlaggedReminders: UILabel!
    let colorArray = [ 0x000000, 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xfcff00, 0xd2ff00, 0x05c000, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0]
    let listTypes = ["list.bullet", "smiley.fill", "tag","flame.fill","doc.text.fill","bookmark.fill"];
    
    var listItems: [ListItem] = []
    var reminderItems: [ReminderItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        searchBar.searchBarStyle = .minimal
        allView.layer.cornerRadius = 10
        flaggedView.layer.cornerRadius = 10
        listTable.layer.cornerRadius = 10
        listTable.dataSource = self;
        listTable.delegate = self
        searchBar.delegate = self;
        listTable.tableFooterView = UIView(frame: .zero);
        //navigationItem.titleView = searchBar;
        updateLabels();
       /* searchBar.sizeToFit()
        navigationItem.titleView = searchBar*/

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addListItemSegue" {
            if let destination = segue.destination as? ListViewController {
                destination.listViewDelegate = self;
            }
        }
        else if segue.identifier == "newReminderSegue" {
            
            if let destination = segue.destination as? ReminderViewController {
                destination.reminderDelegate = self;
            }
            
            
        }
        
    }
    @IBAction func newReminderTapped(_ sender: Any) {
        if(listItems.count <= 0) {
           let alertSuccess = UIAlertController(title: "List Item Required", message: "No list item found. Please add list item before adding a new reminder", preferredStyle: .alert)
            let okAction = UIAlertAction (title: "OK", style: .cancel, handler: nil)
            alertSuccess.addAction(okAction)

           self.present(alertSuccess, animated: true, completion: nil)
        }
        else{
        performSegue(withIdentifier: "newReminderSegue", sender: nil)
        }
        
    }
    
    func addNewList(listItem: ListItem) {
        listItems.append(listItem);
        updateView()
    }
    
    func getListItems() -> [ListItem]{
        return listItems;
    }
    
    func addListItem(item: ReminderItem){
        reminderItems.append(item);
        updateView();
    }
    
    func updateView(){
        updateLabels();
        listTable.reloadData();
    }
    func updateLabels(){
        numberOfReminders.text = String(reminderItems.count)
        var flaggedItems = 0;
        reminderItems.forEach {
            if( $0.flag == true ){
                flaggedItems += 1;
            }
        }
        numberOfFlaggedReminders.text = String(flaggedItems)
        
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return listItems.count
       }
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listViewCell") as! ListViewCell;
        let listItem = listItems[indexPath.row];
        var reminderCounts = 0;
        reminderItems.forEach {
            if( $0.listItemId == listItem.id ){
                reminderCounts += 1 ;
            }
        }
        cell.configure(name: listItem.name, imageName: listItem.listImage, imageColor: uiColorFromHex(rgbValue: listItem.colorCode),  reminderCount: reminderCounts)
        cell.selectionStyle = .none;
           
        return cell;
           
       }
    
}

extension ViewController: UISearchBarDelegate {
   func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       /* searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsCancelButton = true*/
     performSegue(withIdentifier: "searchSegue", sender: nil)
    }
    /*func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }*/
    
}

