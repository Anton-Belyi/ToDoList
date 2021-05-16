//
//  MainVC.swift
//  ToDoList
//
//  Created by Антон Белый on 12.05.2021.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    //Create Table
    let tableV: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var models = [Tasks]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do List"
        view.addSubview(tableV)
        tableV.dataSource = self
        tableV.frame = view.bounds
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "Новая задача", message: "Введите новую задачу", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Сохранить", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createTasks(name: text)
        }))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }

    
    
    
    // MARK: CoreData
    
    func getAllTasks() {
        
        do {
            models = try context.fetch(Tasks.fetchRequest())
            DispatchQueue.main.async {
                self.tableV.reloadData()
            }
        } catch  {
            // Error
        }
    }
    
    func createTasks(name: String) {
        let newTasks = Tasks(context: context)
        newTasks.title = title
        newTasks.createdDate = Date()
        
        do {
            try context.save()
            getAllTasks()
        } catch {
            
        }
        
    }
    
    func deleteTasks(tasks: Tasks) {
        context.delete(tasks)
        do {
            try context.save()
        } catch {
            
        }

        
    }
    
    func updateTasks(tasks: Tasks, newName: String) {
        tasks.title = newName
        do {
            try context.save()
        } catch {
            
        }
    }
}
