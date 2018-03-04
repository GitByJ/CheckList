//
//  ViewController.swift
//  CheckList
//
//  Created by Jae-Jun Shin on 19/02/2018.
//  Copyright © 2018 Jaejun Shin. All rights reserved.
//

import UIKit
import CoreData

class CheckListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
//       print(dataFilePath)
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
        //        if let items = defaults.array(forKey: "CheckListArray") as? [Item] {
        //            itemArray = items
    }


//MARK - Tableview Datasource Methods

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    print("cellForRowAt triggered")
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
    let item = itemArray[indexPath.row]
    
    cell.textLabel?.text = item.title
    
    cell.accessoryType = item.done ? .checkmark : .none
    
    
    //        if item.done == true {
    //            cell.accessoryType = .checkmark
    //        } else {
    //            cell.accessoryType = .none
    //        }
    
    return cell
    
}

//MARK: - TableView Delegate Methods

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        print(itemArray[indexPath.row])
    
//    context.delete(itemArray[indexPath.row])
//    itemArray.remove(at: indexPath.row)
    
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    saveItems()
    
    //        if itemArray[indexPath.row].done == false {
    //            itemArray[indexPath.row].done = true
    //        } else {
    //            itemArray[indexPath.row].done = false
    //        }
    
   
    
    //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
    //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
    //        } else {
    //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    //        }
    
    tableView.deselectRow(at: indexPath, animated: true)
}

//MARK: - Add new items

@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add new items", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add new one", style: .default) { (action) in
        
        
        let newItem = Item(context: self.context)
        
        newItem.title = textField.text!
        newItem.done = false
        newItem.parentCategory = self.selectedCategory
        
        self.itemArray.append(newItem)
        
        self.saveItems()
        
    }
    
    alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Create new item"
        textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
}
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error Saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print(error)
        }
        
        tableView.reloadData()
        
    }
    
    

}

//MARK: - SearchBar methods

extension CheckListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
        
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




