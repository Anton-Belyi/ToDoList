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
        getAllTasks()
        tableV.dataSource = self
        tableV.delegate = self
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
        present(alert, animated: true)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "Редактировать", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Редактировать", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "Редактировать задачу", message: "Редактировать вашу задачу", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.title
            alert.addAction(UIAlertAction(title: "Сохранить", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.updateTasks(tasks: item, newName: newName)
            }))
         
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            self?.deleteTasks(tasks: item)
        }))
        present(sheet,animated: true)
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
