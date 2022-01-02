//
//  ViewController.swift
//  ToDoList
//
//  Created by Faruk YILDIRIM on 31.12.2021.
//

import UIKit

class ToDoListViewController: UIViewController {
    
    // MARK: - Properties
    
    var tableView = UITableView()
    var tableData = ["Beach", "Clubs", "Chill", "Dance"]
    let cellID = "cell"
    
    func makeLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // important!
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

        
    }
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        setupNavigationBar()
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: view.frame.width, height: view.frame.height)
    }
    
    func setupNavigationBar() {
        self.navigationItem.setTitle(title: "Checklist", subtitle: "1 / 7")
        let addTaskBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTaskBarButtonPressed))
        
        self.navigationItem.rightBarButtonItem = addTaskBarButton
    }

    // MARK: - Selectors
    
    @objc func addTaskBarButtonPressed(){
        let alertController = UIAlertController(title: "Add New Task", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: nil)
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
    }
    
}

// MARK: - TableView

extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        if indexPath.section == 0 {
            cell.imageView?.image = UIImage(systemName: "arrow.left.circle")
            cell.textLabel?.text  =  "This is row \(tableData[indexPath.row])"
        
        }else{
            cell.imageView?.image = UIImage(systemName: "checkmark.circle")
            cell.imageView?.tintColor = .gray
            cell.textLabel?.attributedText  = NSAttributedString(string: "This is row \(tableData[indexPath.row])").withStrikeThrough(1)
            cell.textLabel?.textColor = .gray
        }

        return cell
      }
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return tableData.count
      }
        
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            print("done \(indexPath.row)")
            completionHandler(true)
        }
        
        doneAction.title = "Done"
        doneAction.backgroundColor = .systemGreen
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "To Do List" : "Done"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           print("Delete")
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

