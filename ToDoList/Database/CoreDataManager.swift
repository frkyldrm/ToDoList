//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Faruk YILDIRIM on 2.01.2022.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func createToDo(title: String, status: Bool) {
        let context = persistentContainer.viewContext
        let toDo = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
        
        toDo.setValue(Int.random(in:1..<5324345), forKey: "id")
        toDo.setValue(title, forKey: "title")
        toDo.setValue(status, forKey: "status")
        
        do {
            try context.save()
        } catch let err {
            print("failed to save context with new toDo:",err)
        }
    }
    
    func deleteToDo(id: Double) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ToDo>(entityName: "ToDo")

        do {
            let toDos = try context.fetch(fetchRequest)
             try toDos.forEach { (fetchedToDo) in
                if fetchedToDo.id == id {
                    //fetchedToDo.status = true
                     context.delete(fetchedToDo)
               
                      try context.save()
                }
            }
        } catch let err {
            print("failed to fetch todo to update",err)
        }
    }
    
    func updateToDo(id: Double, title: String) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ToDo>(entityName: "ToDo")

        do {
            let toDos = try context.fetch(fetchRequest)
            try toDos.forEach { (fetchedToDo) in
                if fetchedToDo.id == id {
                    fetchedToDo.id = id
                    fetchedToDo.title = title
                    fetchedToDo.status = false
                    try context.save()
                }
            }
        } catch let err {
            print("failed to fetch todo to update",err)
        }
    }
    
    func fetchToDos() -> [ToDo] {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<ToDo>(entityName: "ToDo")
           
        do {
            let toDos = try context.fetch(fetchRequest)
            return toDos
        } catch let err {
            print("failed to fetch todos from context", err)
            return []
        }
        
    
    }
     
    func fetchToDoActive() -> [ToDo] {
        let context = persistentContainer.viewContext
        

            let fetchRequest = NSFetchRequest<ToDo>(entityName: "ToDo")
            fetchRequest.predicate = NSPredicate(format: "status = 1")
            
            do {
                let toDos = try context.fetch(fetchRequest)
                return toDos
            } catch let err {
                print("failed to fetch todos from context", err)
                return []
            }
        }

    
    func fetchToDoDone() -> [ToDo] {
        let context = persistentContainer.viewContext
        
 
            let fetchRequest = NSFetchRequest<ToDo>(entityName: "ToDo")
            fetchRequest.predicate = NSPredicate(format: "status = 0")
            
            do {
                let toDos = try context.fetch(fetchRequest)
                return toDos
            } catch let err {
                print("failed to fetch todos from context", err)
                return []
            }
        }
    
    
}
