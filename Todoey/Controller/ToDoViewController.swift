//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet{                     //this method called when value sets to not nil! to not to crash the app
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - cell initializing
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoViewCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        //Ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        context.delete(itemArray[indexPath.row])  //cruD
//        itemArray.remove(at: indexPath.row)       //deleting objects from db
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done  //check or uncheck checkmark
        
        saveTheData()
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Bar button item
    
    @IBAction func barButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Item to Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (alert) in
            //what will happen when the user clicks the Add Item button on our UIAlert
            
            let newItem = Item(context: self.context) //create of CRUD
            newItem.title = textField.text!           //Crud
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveTheData()
        }
        alert.addAction(action) //making action
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Write smth"
            textField = addTextField //local written text equalize to global text
        }
        present(alert, animated: true, completion: nil) //show alert
    }
//MARK: - Save the Data to context
    
    func saveTheData() {
        do{
            try context.save()      //commits context and save
        }catch{
            print("!!!!!!!!Error at encoding, \(error)")
        }
        tableView.reloadData() //update list after appending text from alert
        
    }
//MARK: - load the data from datamodel cRud
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),for predicate: NSPredicate? = nil) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate]) //checking for both predicate to not nil
        } else {
            request.predicate = categoryPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        request.predicate = compoundPredicate
        
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("!!!!!!!Error when fetching the data from context")
        }
        tableView.reloadData()
    }
}

//MARK: - Search Bar Method

extension ToDoViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //searching by string syntax
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]       //sorting
        
        loadItems(with: request,for: predicate)
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

