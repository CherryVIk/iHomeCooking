//
//  CategoriesController.swift
//  iHomeCooking
//
//  Created by Victoria Boichenko on 22.08.2020.
//  Copyright © 2020 Victoria Boichenko. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriesController: UITableViewController {
    
    //    var categories = ["01","02","03"]
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryID", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Nothing was entered"
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "GoToItems" {
           let destinationVC = segue.destination as! ItemsController
            if let indexPath = tableView.indexPathForSelectedRow {
                      destinationVC.selectedCategory = categories?[indexPath.row]
                  }
       }
    }
    
    //MARK: - Adding New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Add category", style: .default, handler: { (action) in
            let textField = alert.textFields![0]
            if textField.text?.count != 0 {
                let newCategory = Category()
                newCategory.name = textField.text!
                self.saveCategories(newCategory)
            }
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategories(_ category : Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch  {
            print("Error adding category in realm")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    

    
}

