//
//  OverView.swift
//  ToDo
//
//  Created by Raphael Härle on 28.04.24.
//

import SwiftUI

struct EditView: View {
    @Binding var todo : Todo
    @Binding var oldTodo : Todo
    @ObservedObject var manager : TodoManager
    @Environment(\.dismiss) private var dismiss
    
    var formatter = DateFormatter()
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack{
                        Label("", systemImage: "chevron.backward.circle")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .position(CGPoint(x: 50, y: 20))
                            .onTapGesture {
                                print("übersicht verlassen")
                                dismiss()
                            }
                     
                    Text("Bearbeiten")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                .frame(width: geometry.size.width, height: 70)
                VStack(alignment: .center){
                    TextField("Titel", text: $todo.titel)
                        .padding(.horizontal, 10)
                        .foregroundColor(.white)
                        .frame(width:geometry.size.width-50, height: 50)
                        .background(Color(UIColor.lightGray))
                        .cornerRadius(15)

                    TextField("Beschreibung", text: $todo.description)
                      
                        .padding(.horizontal, 10)
                        .foregroundColor(.white)
                        .frame(width:geometry.size.width-50, height: 50)
                        .background(Color(UIColor.lightGray))
                        .cornerRadius(15)
                    
                    Text("Fälligkeitsdatum:")
                    HStack{
                        DatePicker("", selection: $todo.expiration, displayedComponents: .date)
                            .padding()
                            .foregroundColor(.white)
                            .frame(width: geometry.size.width/2)
                    }
                    
                    Text("Speichern")
                        .frame(width: 200, height: 50)
                        .background(Color(UIColor.lightGray))
                        .cornerRadius(15.0)
                        .onTapGesture {
                            
                            let todo = Todo( id: UUID(),
                                    titel: todo.titel, description: todo.description, expiration: todo.expiration)
                            print(todo)
                            manager.editTodo(for: &oldTodo, updateValue: todo)
                            dismiss()
                      
                            }
                }
            }
        }.background(.gray)
       
    }
}

#Preview {
    ContentView()
}
