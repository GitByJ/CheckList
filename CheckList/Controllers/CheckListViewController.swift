//
//  ViewController.swift
//  CheckList
//
//  Created by Jae-Jun Shin on 19/02/2018.
//  Copyright © 2018 Jaejun Shin. All rights reserved.
//

import UIKit
import RealmSwift

class CheckListViewController: UITableViewController {
    
    let realm = try! Realm()

    var checkListItem : Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    


//MARK - Tableview Datasource Methods

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return checkListItem?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
        if let item = checkListItem?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item Added"
        }
    
    
    
    return cell
    
}

//MARK: - TableView Delegate Methods

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let item = checkListItem?[indexPath.row] {
        do {
            try realm.write {
//                realm.delete(item)
                item.done = !item.done
            }
        } catch {
            print(error)
        }
    }
    
    tableView.reloadData()
    
    
    tableView.deselectRow(at: indexPath, animated: true)
}

//MARK: - Add new items

@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add new items", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add new one", style: .default) { (action) in
        
        if let currecntCategory = self.selectedCategory {
            do {
                try self.realm.write {
                let newItem = Item()
                
                newItem.title = textField.text!
                newItem.dateCreated = Data()
                currecntCategory.items.append(newItem)
                }
            } catch {
                print(error)
            }
            
        }
        
        self.tableView.reloadData()
        
    }
    
    alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Create new item"
        textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
}
    
    func saveItems(item : Item) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error Saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
    func loadItems() {
        
        checkListItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }
    
    

}

//MARK: - SearchBar methods

extension CheckListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        checkListItem  = checkListItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)


    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}




