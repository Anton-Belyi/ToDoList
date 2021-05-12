//
//  MainVC.swift
//  ToDoList
//
//  Created by Антон Белый on 12.05.2021.
//

import UIKit

class MainVC: UITableViewController {

    var tasks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return tasks.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]


        return cell
    }
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Task", message: "Enter Task", preferredStyle: .alert)
        let saveTask = UIAlertAction(title: "Save Task", style: .default) { action in
            let textField = alertController.textFields?.first
            if let newTask = textField?.text {
                self.tasks.insert(newTask, at: 0)
                self.tableView.reloadData()
            }
        }
        
        alertController.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        
        alertController.addAction(saveTask)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
