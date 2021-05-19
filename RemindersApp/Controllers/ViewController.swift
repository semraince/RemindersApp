//
//  ViewController.swift
//  RemindersApp
//
//  Copyright © 2021 semra. All rights reserved.
//

import UIKit
import CoreData

protocol ListUpdateControllerDelagate: class {
    func addNewList(listItem: ListItemDTO);
}

protocol ReminderUpdateControllerDelegate: class {
    func getListItems() -> [ListItem];
    func addListItem(item: ReminderItemDTO);
}
protocol SearchViewDelegate: class {
    func getReminderItems() -> [ReminderItem];
    func getListItems() -> [ListItem];
}

class ViewController: UIViewController, ListUpdateControllerDelagate, ReminderUpdateControllerDelegate, SearchViewDelegate {

    
   
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var flaggedView: UIView!
    @IBOutlet weak var listTable: UITableView!
    
    @IBOutlet weak var numberOfReminders: UILabel!
    var searchViewController: SearchViewController!
   
    @IBOutlet weak var numberOfFlaggedReminders: UILabel!
    let colorArray = [ 0x000000, 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xfcff00, 0xd2ff00, 0x05c000, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0]
    let listTypes = ["list.bullet", "smiley.fill", "tag","flame.fill","doc.text.fill","bookmark.fill"];
    
    var listItems: [ListItem] = []
    var reminderItems: [ReminderItem] = []
    var searchController : UISearchController!//(searchResultsController: SearchViewController());
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
         searchViewController = storyboard!.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        searchViewController.searchViewDelegate = self;
        searchController = UISearchController(searchResultsController: searchViewController);
       // searchBar.searchBarStyle = .minimal
        allView.layer.cornerRadius = 10
        flaggedView.layer.cornerRadius = 10
        listTable.layer.cornerRadius = 10
        listTable.dataSource = self;
        listTable.delegate = self
        //searchBar.delegate = self;
        listTable.tableFooterView = UIView(frame: .zero);
        //navigationItem.titleView = searchBar;
        updateLabels();
        navigationItem.searchController = searchController
        self.definesPresentationContext = true
        searchController!.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        searchController.searchResultsUpdater = searchViewController
        searchController.dimsBackgroundDuringPresentation = true
        searchController.definesPresentationContext = true
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        updateView();
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
    
    func addNewList(listItem: ListItemDTO) {
        //listItems.append(listItem);
        createNewList(listItem: listItem);
        updateView()
    }
    func createNewList(listItem: ListItemDTO){
        let listItemModel = ListItem(context: context);
        listItemModel.colorCode = Int32(listItem.colorCode);
        listItemModel.id = listItem.id;
        listItemModel.name = listItem.name
        listItemModel.listImage = listItem.listImage
        do {
            try context.save()
        }
        catch{
        }
                          
    }
    func getListItems() -> [ListItem]{
        return listItems;
    }
    
    func addListItem(item: ReminderItemDTO){
        createReminderItem(item: item)
        updateView();
    }
    func createReminderItem(item: ReminderItemDTO){
        let reminderModel = ReminderItem(context: context);
        reminderModel.flag = item.flag;
        reminderModel.id = item.id;
        reminderModel.listItemId = item.listItemId;
        reminderModel.notes = item.notes;
        reminderModel.status = Int32(item.status)
        reminderModel.priority = Int32(item.priority)
        reminderModel.title = item.title;
        do {
            try context.save()
        }
        catch{
        }
        
    }
    
    func updateView(){
        do {
            
            try listItems = context.fetch(ListItem.fetchRequest())
            try reminderItems = context.fetch(ReminderItem.fetchRequest());
            DispatchQueue.main.async {
                self.updateLabels();
                self.listTable.reloadData();
            }
        }
        catch {
                
        }
        
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
    
    func getReminderItems() -> [ReminderItem] {
        return reminderItems;
    }
    
    func deleteAllData(entity: String)
    {
       
        let managedContext = context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
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
        print("id of ", listItem.name, " is" , listItem.id)
        cell.configure(name: listItem.name!, imageName: listItem.listImage!, imageColor: uiColorFromHex(rgbValue: Int(listItem.colorCode)),  reminderCount: reminderCounts)
        cell.selectionStyle = .none;
           
        return cell;
           
       }
    
}

/*extension ViewController: UISearchBarDelegate {
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
    
}*/

