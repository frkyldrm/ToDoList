//
//  ViewController.swift
//  ToDoList
//
//  Created by Faruk YILDIRIM on 31.12.2021.
//

import UIKit

class ToDoListViewController: UIViewController {
    
    // MARK: - Properties
    
    var todoTask = CoreDataManager.shared.fetchToDoActive()
    var doneTask = CoreDataManager.shared.fetchToDoDone()
    
    
    var tableView = UITableView()
    var addTextFiel: String?
    var tableData = CoreDataManager.shared.fetchToDos()
    let cellID = "cell_id"
    
    func makeLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .yellow
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        
        return label
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.dragInteractionEnabled = true
        tableView.backgroundColor = UIColor.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        configureViewComponents()
        refreshToDo()
    }
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        setupNavigationBar()
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: view.frame.width, height: view.frame.height)
    }
    
    func setupNavigationBar() {
        self.navigationItem.setTitle(title: "Checklist", subtitle: "\(doneTask.count) / \(tableData.count)")
        let addTaskBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTaskBarButtonPressed))
        
        self.navigationItem.rightBarButtonItem = addTaskBarButton
    }
    
    func refreshToDo() {
        self.doneTask = CoreDataManager.shared.fetchToDoDone()
        self.tableData = CoreDataManager.shared.fetchToDos()
        self.tableView.reloadData()
        setupNavigationBar()
    }
    
    // MARK: - Selectors
    
    @objc func addTaskBarButtonPressed(){
        let alertController = UIAlertController(title: "Add New Task", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            CoreDataManager.shared.createToDo(title: self.addTextFiel!, status: true)
            self.refreshToDo()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter task name."
            textField.addTarget(self, action: #selector(self.handleTextChange), for: .editingChanged)
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        addAction.isEnabled = false
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleTextChange(_ sender: UITextField) {
        guard let alertController = presentedViewController as? UIAlertController,
              let addAction = alertController.actions.first,
              let text = sender.text
        else { return }
        
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
        self.addTextFiel = text
    }
    
}

// MARK: - TableView

extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        //let cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        
        var section = tableData[indexPath.row].status == true ? 1 : 0

        if indexPath.section == 0 && section == 1 {
            
            cell.imageView?.image = UIImage(systemName: "arrow.left.circle")
            cell.textLabel?.text  = tableData[indexPath.row].title!
        } else if indexPath.section == 1 && section == 0 {
                cell.imageView?.image = UIImage(systemName: "checkmark.circle")
                cell.imageView?.tintColor = .gray
                cell.textLabel?.attributedText = NSAttributedString(string: "\(tableData[indexPath.row].title!)").withStrikeThrough(1)
                cell.textLabel?.textColor = .gray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableData[indexPath.row].id)
        print(tableData[indexPath.row].title!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        self.tableData.forEach { (toDo) in
            if section == 0 && toDo.status == true {
                count += 1
            } else if section == 1 && toDo.status == false {
                count += 1
            }
        }
        return count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "To Do List" : "Done"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            CoreDataManager.shared.updateToDo(id: self.tableData[indexPath.row].id, title: self.tableData[indexPath.row].title!)
            self.refreshToDo()
            print(self.tableData[indexPath.row].id)
            print(self.tableData[indexPath.row].title!)
            completionHandler(true)
        }
        
        doneAction.title = "Done"
        doneAction.backgroundColor = .systemGreen
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.shared.deleteToDo(id: Double(self.tableData[indexPath.row].id))
            self.refreshToDo()
        }
    }
}

extension ToDoListViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = tableData[indexPath.row]
        return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        let mover = tableData.remove(at: sourceIndexPath.row)
        tableData.insert(mover, at: destinationIndexPath.row)
    }
    
}

