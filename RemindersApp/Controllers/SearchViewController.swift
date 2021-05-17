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
   
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel!.text = filteredItems[indexPath.row].title
        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 0 else { return }
        filteredItems = items.filter { $0.title.range(of: searchText) != nil }
        print(items)
        print(filteredItems)
       // print("update search results for \(searchText) - items are now: \(filteredItems)")
        tableView.reloadData()
    }
}
