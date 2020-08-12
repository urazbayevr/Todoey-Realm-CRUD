//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Рамазан  on 8/6/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
//MARK: - viewWillAppear overriding
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
//MARK: - tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Don`t have added Categories"
        if let categoryForColor = categories?[indexPath.row]{
            guard let categoryColour = UIColor(hexString: categoryForColor.color) else {fatalError()}
            cell.backgroundColor = categoryColour //gets fit bg color by the String of UI
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        return cell
    }
//MARK: - Save the Data to context
    func saveTheData(category: Category) {
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("!!!!!!!!Error at encoding, \(error)")
        }
        tableView.reloadData() //update list after appending text from alert
        
    }
//MARK: - load the data from datamodel cRud
    func loadCategory() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
//MARK: - Delete data from swipe
    override func updateModel(at indexpath: IndexPath) {
        if let category = self.categories?[indexpath.row]{
            do{
                try self.realm.write{ ///updates the database
                    self.realm.delete(category)
                }
            } catch {
                print("Error catched on Updating data\(error)")
            }
        }
    }
//MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alert) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.saveTheData(category: newCategory)
        }
        alert.addAction(action) //making action
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Add a new category"
            textField = addTextField
        }
        present(alert, animated: true, completion: nil)
    }
//MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: "goToItems", sender: self)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "items_storyboard") as! ToDoViewController
        vc.selectedCategory = categories?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let destinationVC = segue.destination as! ToDoViewController
    //
    //        if let indexPath = tableView.indexPathForSelectedRow{
    //            destinationVC.selectedCategory = categories[indexPath.row]  //perform the selected row to TodoVC
    //        }
    //    }
}

