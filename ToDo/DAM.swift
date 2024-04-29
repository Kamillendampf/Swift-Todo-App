//
//  DAOtodo.swift
//  ToDo
//
//  Created by Raphael Härle on 28.04.24.
//

import Foundation


class DataAccessModule{
    let userDefaults = UserDefaults.standard
    
    func save(todos: [Todo]){
        let convertToJson = try? JSONEncoder().encode(todos)
            userDefaults.set(convertToJson, forKey: "todos")
    }
    
    func load() -> [Todo]{
        if let jsondData =  userDefaults.data(forKey: "todos"){
            if let todos = try? JSONDecoder().decode([Todo].self, from: jsondData) {
                return todos
            }
        }
      return []
    }
}
