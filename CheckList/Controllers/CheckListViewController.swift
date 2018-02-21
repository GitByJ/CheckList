//
//  ViewController.swift
//  CheckList
//
//  Created by Jae-Jun Shin on 19/02/2018.
//  Copyright © 2018 Jaejun Shin. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       print(dataFilePath)
        
        loadItems()
        
        
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
        
        let newItem = Item()
        newItem.title = textField.text!
        
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
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error, encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding Item array, \(error)")
            }
            
        }
        
    }

}
