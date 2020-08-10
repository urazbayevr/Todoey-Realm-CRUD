//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: UITableViewController {
    let realm = try! Realm()
    var itemObject: Results<Item>?
    
    var selectedCategory: Category? {
        didSet{                     //this method called when value sets to not nil! to not to crash the app
            loadItems()
        }
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    //MARK: - cell initializing
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemObject?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoViewCell", for: indexPath)
        if let item = itemObject?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else{
            cell.textLabel?.text = "No Items have been added yet"
        }
        return cell
    }
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemObject?[indexPath.row]{
            do{
                try realm.write{ ///updates the database
//                    realm.delete(item) ///deletes the picked object
                    item.done = !item.done
                }
            } catch {
                print("Error catched on Updating data\(error)")
            }
        }
        tableView.reloadData()
    }
    
    //MARK: - Bar button item
    
    @IBAction func barButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Item to Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (alert) in
            //what will happen when the user clicks the Add Item button on our UIAlert
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{ //  crUd
                        let newItem = Item() //create of CRUD
                        newItem.title = textField.text!           //Crud
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving new items \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addAction(action) //making action
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Write smth"
            textField = addTextField //local written text equalize to global text
        }
        present(alert, animated: true, completion: nil) //show alert
    }
//MARK: - load the data from datamodel cRud
    
    func loadItems() {
        itemObject = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - Search Bar Method
extension ToDoViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemObject = itemObject?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else{
            searchBarSearchButtonClicked(searchBar)
        }
    }
}

