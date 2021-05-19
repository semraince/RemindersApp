//
//  SearchViewController.swift
//  RemindersApp
//
//  Copyright © 2021 semra. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items: [ReminderItem]!
    
    private var filteredItems: [ReminderItem] = []
    weak var searchViewDelegate: SearchViewDelegate?
    var filteredSections: [String: [ReminderItem]] = [:]
    var filteredKeys: [String] = [];
    /* @IBOutlet var searchBar: UISearchBar!*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
    }
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = searchViewDelegate?.getReminderItems()
    
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredKeys.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSections[filteredKeys[section]]?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let key = filteredKeys[indexPath.section]
        cell.textLabel?.text = filteredSections[key]?[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var listItem = searchViewDelegate?.getListItems().filter{ $0.id == filteredKeys[section] }
        return listItem?.first?.name
        
    }
    //viewForHea
}

extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 0 else { return }
        filteredItems = items.filter { $0.title!.range(of: searchText) != nil }
       // print(items)
        //print(filteredItems)
     filteredSections = Dictionary(grouping: filteredItems, by: { $0.listItemId! })
        filteredKeys = Array(filteredSections.keys);
        print("burasi")
        print(filteredSections)
       // print("update search results for \(searchText) - items are now: \(filteredItems)")
        tableView.reloadData()
    }
    
}
