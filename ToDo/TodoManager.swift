//
//  TodoManager.swift
//  ToDo
//
//  Created by Raphael Härle on 28.04.24.
//

import Foundation

struct Todo: Encodable, Decodable, Hashable, Identifiable{
    var id: UUID
    var titel : String
    var description : String
    var expiration :  Date
    
}

class TodoManager : ObservableObject{
    @Published var todos : [Todo] = []
    @Published var sortedTodos : [Todo] = []
    
    var dam = DataAccessModule()
    
    init() {
       refrasch()
    }
    
    func addTodo(todo: Todo){
        todos.append(todo)
        dam.save(todos: todos)
    }
    
    func deletTodo(todo: Todo){
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos.remove(at: index)
                  }
        dam.save(todos: todos)
    }
    
    func editTodo(for todo: inout Todo, updateValue: Todo){
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
                      todos[index] = updateValue
            print("Wurde gespeichert")
                  }
        dam.save(todos: todos)
    }
    
    func refrasch(){
        todos = dam.load()
        sortedTodos = dam.load().sorted(by: { $0.expiration < $1.expiration })
        print(sortedTodos)
    }
    

}
