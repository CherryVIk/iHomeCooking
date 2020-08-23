//
//  ItemsController.swift
//  iHomeCooking
//
//  Created by Victoria Boichenko on 22.08.2020.
//  Copyright © 2020 Victoria Boichenko. All rights reserved.
//

import UIKit
import RealmSwift

class ItemsController: UITableViewController {
    
    
    let realm = try! Realm()
    var items: Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let safeCategory = selectedCategory {
            title = safeCategory.name
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemID", for: indexPath)
        
        cell.textLabel?.text = items?[indexPath.row].name ?? "Nothing entered"
        
        
        return cell
    }

    //MARK: - Adding New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let addItemManually = UIAlertAction(title: "Add item manually", style: .default, handler: { (action) in
            self.addEnterAlert()
            
        })
        let takePicture = UIAlertAction(title: "Take picture of item", style: .default) { (action) in
            self.performSegue(withIdentifier: "GoToEditing", sender: self)
        }
        let cancel = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alert.addAction(addItemManually)
        alert.addAction(takePicture)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addEnterAlert(){
        let enterName = UIAlertController(title: "Manual entering", message: "", preferredStyle: .alert)
        enterName.addTextField { (textField) in
            textField.placeholder = "Enter name"
        }
        enterName.addTextField{ (textField) in
            textField.placeholder = "Enter price"
        }
        
        enterName.addAction(UIAlertAction(title: "Add item", style: .default){ (action) in
            let firstTextField = enterName.textFields![0]
            let secondTextField = enterName.textFields![1]
            if firstTextField.text?.count != 0 {
                let product = Item()
                product.name = firstTextField.text!
                
                if secondTextField.text?.count != 0 {
                    guard let productPrice = Double(secondTextField.text!) else {
                        fatalError("\(secondTextField.text!) is not a double")
                    }
                    product.price = productPrice
                }
                  if let currentCategory = self.selectedCategory {
                                  
                      do {
                          try self.realm.write({
                              currentCategory.items.append(product)
                              
                          })
                      } catch  {
                          print("Error saving data, \(error)")
                      }
                      
                      self.tableView.reloadData()
                  }
                              
                self.tableView.reloadData()
            }
        })
        present(enterName, animated: true, completion: nil)
    }
    //MARK: - Data Manipulation Methods
    
    func loadData(){
        items = selectedCategory?.items.sorted(byKeyPath: "name")
        tableView.reloadData()
    }
    
}
