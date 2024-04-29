//
//  OverView.swift
//  ToDo
//
//  Created by Raphael Härle on 28.04.24.
//

import SwiftUI

struct OverView: View {
    @Binding var todo : Todo
    @State var isEditPresented = false
    @ObservedObject var manager = TodoManager()
    @Environment(\.dismiss) private var dismiss
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack{
                    HStack{
                        Label("", systemImage: "chevron.backward.circle")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .position(CGPoint(x: 50, y: 20))
                            .onTapGesture {
                                manager.refrasch()
                                dismiss()
                            }
                        Text("Bearbeiten")
                            .padding(3)
                            .frame(width: 110, height: 25)
                            .background(Color(UIColor.lightGray))
                            .opacity(0.6)
                            .cornerRadius(50)
                            .position(CGPoint(x: 100, y: 20))
                            .onTapGesture {
                                isEditPresented = true
                            }
                    }
                    Text("Übersicht")
                        .font(.title)
                        .foregroundStyle(.white)
                
                }.fullScreenCover(isPresented:$isEditPresented, content: {
                    EditView(todo: $todo, oldTodo: $todo, manager: manager)
                })
                .frame(width: geometry.size.width, height: 70)
                VStack(alignment: .center){
                    Text(todo.titel)
                        .font(.title)
                        .foregroundColor(.white)
                        .onAppear{
                            print(todo)
                        }
                    Text("Beschreibung:")
                        .foregroundColor(.white)
                    Text(todo.description)
                        .foregroundColor(.white)
                    Text("Fälligkeitsdatum:")
                        .foregroundColor(.white)
                    let date:String = formatter.string(from: todo.expiration)
                    Text(date)
                        .foregroundColor(.white)
                }.padding(.vertical, 30)
                HStack{
                    Text("Löschen")
                        .padding(10)
                        .frame(width: 200, height: 50)
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .onTapGesture {
                            manager.deletTodo(todo: todo)
                            manager.refrasch()
                            dismiss()
                        }
                }.padding(.vertical, 150)
            }
        } .background(.gray)
    }
}

#Preview {
    ContentView()
}
