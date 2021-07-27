//
//  ContentView.swift
//  SwiftUIChapters
//
//  Created by Bhanu Pratap on 23/07/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var newChapter = ""
    @State private var chapterList: [Chapter] = []
    
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                HStack {
                    TextField("Add chapter...", text:$newChapter).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        guard !self.newChapter.isEmpty else { return }
                        self.chapterList.append(Chapter(name: self.newChapter))
                        self.newChapter = ""
                        self.save()
                    }) {
                        Image(systemName: "plus")
                    }.padding(.leading, 5)
                }.padding()
                
                
                List{
                    ForEach(chapterList) { chapter in
                        Text(chapter.name)
                    }.onDelete(perform: self.deleteChapter(offset:))
                }
            }
            
            
            .navigationTitle("Chapter list")
        }.onAppear(perform: self.loadData)
    }
    
    func loadData() {
    
        if let data = UserDefaults.standard.value(forKey: "chapterList") as? Data {
            if let chapters = try? PropertyListDecoder().decode(Array<Chapter>.self, from: data){
                self.chapterList = chapters
            }
        }
    }
    
    func deleteChapter(offset: IndexSet) {
        self.chapterList.remove(atOffsets: offset)
        self.save()
    }
    
    func save() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.chapterList), forKey: "chapterList")
    }
}

struct Chapter: Identifiable, Codable {
    var id = UUID()
    let name: String
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewLayout(.device)
                .previewDevice("iPhone 11")
            ContentView()
            ContentView()
        }
    }
}
