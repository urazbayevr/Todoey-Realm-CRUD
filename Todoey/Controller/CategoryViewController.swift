//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Рамазан  on 8/6/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
//MARK: - Save the Data to context
    func saveTheData() {
        do{
            try context.save()
        }catch{
            print("!!!!!!!!Error at encoding, \(error)")
        }
        tableView.reloadData() //update list after appending text from alert
        
    }
//MARK: - load the data from datamodel cRud
    func loadCategory() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        } catch {
            print("!!!!!!!Error when fetching the data from context \(error)")
        }
        tableView.reloadData()
    }
//MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alert) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveTheData()
        }
        alert.addAction(action) //making action
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Add a new category"
            textField = addTextField
        }
        present(alert, animated: true, completion: nil)
    }
//MARK: - tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
//MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "goToItems", sender: self)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "items_storyboard") as! ToDoViewController
        vc.selectedCategory = categories[indexPath.row]
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
