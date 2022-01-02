//
//  ViewController.swift
//  ToDoList
//
//  Created by Faruk YILDIRIM on 31.12.2021.
//

import UIKit

class ToDoListViewController: UIViewController {
    
    let tableView = CustomTableView()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .red
        label.text = "WTF"
        return label
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
  
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 10, height: 10)
        titleLabel.center(inView: view)

        
        
        view.addSubview(label)
        label.center(inView: view)
        
   
        
    }


}

