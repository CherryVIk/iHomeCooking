//
//  CategoriesController.swift
//  iHomeCooking
//
//  Created by Victoria Boichenko on 22.08.2020.
//  Copyright © 2020 Victoria Boichenko. All rights reserved.
//

import UIKit

class CategoriesController: UITableViewController {

    var categories = ["01","02","03"]

       override func viewDidLoad() {
           super.viewDidLoad()

           // Uncomment the following line to preserve selection between presentations
           // self.clearsSelectionOnViewWillAppear = false

       }

       // MARK: - Table view data source

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return categories.count
       }

      
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "categoryID", for: indexPath)

           cell.textLabel?.text = categories[indexPath.row]

           return cell
       }
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "GoToItems", sender: self)
       }
      
//MARK: - Adding New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Add category", style: .default, handler: { (action) in
            let textField = alert.textFields![0]
            if textField.text?.count != 0 {
                self.categories.append(textField.text!)
                self.tableView.reloadData()
            }
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    
       /*
       // MARK: - Navigation

       // In a storyboard-based application, you will often want to do a little preparation before navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           // Pass the selected object to the new view controller.
       }
       */



}

