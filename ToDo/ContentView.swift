//
//  ContentView.swift
//  ToDo
//
//  Created by Raphael Härle on 28.04.24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = TodoManager()
    @State var isAddPersented = false
    @State var showAlert = false
    @State var isOverViewPresented = false
    @State private var deleteIndex: Int? = nil
    @State var titelTodo = ""
    @State var descripitonTodo = ""
    @State var dateTodo = Date()
    @State var todoOverView : Todo = Todo(id : UUID(), titel: "", description: "", expiration: Date())
    @State var isSortedPresented = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                Text("ToDos")
                    .foregroundColor(.white)
                    .font(.title)
                
                Text("Sortieren nach Datum")
                    .padding(10)
                    .frame(width: 200, height: 50)
                    .background(Color(UIColor.lightGray))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .onTapGesture {
                       isSortedPresented = !isSortedPresented
                    }
                ScrollView{
                    if (!isSortedPresented){
                        ForEach(manager.todos, id: \.self) { todo in
                            Text(todo.titel)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width-50, height: 50)
                                .background(Color(UIColor.lightGray))
                                .cornerRadius(15)
                                .onTapGesture {
                                    todoOverView = todo
                                    print(todoOverView)
                                    isOverViewPresented = true
                                }
                        }
                        .padding(.horizontal, 10)
                    } else {
                        ForEach(manager.sortedTodos, id: \.self) { todo in
                            Text(todo.titel)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width-50, height: 50)
                                .background(Color(UIColor.lightGray))
                                .cornerRadius(15)
                                .onTapGesture {
                                    todoOverView = todo
                                    print(todoOverView)
                                    isOverViewPresented = true
                                }
                        }
                    }
                }
                .padding(20)
                .fullScreenCover(isPresented: $isOverViewPresented, content: {
                    OverView(todo: $todoOverView, manager: manager)
                })

                Rectangle().frame(width: geometry.size.width+10, height: 1)
                HStack{
                    Label("", systemImage: "plus.app").onTapGesture {
                        isAddPersented = true
                    }
                    .font(.largeTitle)
                    .foregroundColor(.white)
                }
                .padding(10)
                .fullScreenCover(isPresented: $isAddPersented) {
                    VStack{
                        HStack(){
                            VStack{
                                Label("", systemImage: "chevron.backward.circle")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .position(CGPoint(x: 50, y: 10))
                                    .onTapGesture {
                                        isAddPersented = false
                                    }
                                Text("Todo Hinzufügen")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(height: 70)
                        .position(CGPoint(x: geometry.size.width/2, y: 30.0))
                        
                        TextField("Titel", text: $titelTodo)
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .frame(width:geometry.size.width-50, height: 50)
                            .background(Color(UIColor.lightGray))
                            .cornerRadius(15)
                        
                        TextField("Descripition", text: $descripitonTodo)
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .frame(width:geometry.size.width-50, height: 50)
                            .background(Color(UIColor.lightGray))
                            .cornerRadius(15)
                        
                        Text("Fälligkeitsdatum:")
                        HStack{
                            DatePicker("", selection: $dateTodo, displayedComponents: .date)
                                .padding()
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width/2)
                        }
                        
                        Text("Speichern")
                            .frame(width: 200, height: 50)
                            .background(Color(UIColor.lightGray))
                            .cornerRadius(15.0)
                            .onTapGesture {
                                if (titelTodo != "" && descripitonTodo != ""){
                                    let todo = Todo( id: UUID(),
                                        titel: titelTodo, description: descripitonTodo, expiration: dateTodo)
                                    manager.addTodo(todo: todo)
                                    manager.refrasch()
                                    titelTodo = ""
                                    descripitonTodo = ""
                                    dateTodo = Date()
                                    isAddPersented = false
                                } else{
                                    showAlert = true
                                }
                            }
                    }
                        .frame(width:  geometry.size.width, height: geometry.size.height)
                        .background(.gray)
                        
                        .alert(isPresented: $showAlert) {
                            if(titelTodo != "" && descripitonTodo == ""){
                                Alert(
                                    title: Text("Möchten sie ohne Beschriebung vortfahren?"),
                                    message: Text(""),
                                    primaryButton: .default(Text("OK")) {
                                        let todo = Todo( id : UUID(),
                                            titel: titelTodo, description: descripitonTodo, expiration: dateTodo)
                                        manager.addTodo(todo: todo)
                                        manager.refrasch()
                                        titelTodo = ""
                                        dateTodo = Date()
                                        isAddPersented = false
                                    }, secondaryButton: .cancel()
                                )
                            }
                            else{
                                Alert(
                                    title: Text("Unzulässig eingabe"),
                                    message: Text("Die müssen einen Titel und eine Beschtriebung vergeben"),
                                    primaryButton: .default(Text("OK")) {
                                    }, secondaryButton: .cancel()
                                )
                            }
                        }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(.gray)
            
        }
        .background(.gray)
    }
}

#Preview {
    ContentView()
}
