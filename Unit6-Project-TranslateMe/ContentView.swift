//
//  ContentView.swift
//  Unit6-Project-TranslateMe
//
//  Created by Debbie Hirshson on 3/17/25.
//

import SwiftUI


struct ContentView: View {
    @State private var Input: String = ""
    @State private var Output: String = ""
    @State private var Navigate: Bool = false
    @State var manager: TranslationManager
    
    init(){
        manager = TranslationManager()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Translate Me")
                    .font(.system(size: 48))
                
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 5))
                    .foregroundStyle(.purple)
                    .frame(height: 1)
                
                
                TextField("Enter word/phrase", text: $Input)
                    //.textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .padding(3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.purple, lineWidth: 2)
                    )
                    .padding(25)
                
                
                
                Button("Translate Me") {
                    print("button pressed")
                    Task{
                        await translateMessage()
                    }

                }
                
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5.0))
                .tint(.purple)
                .shadow(radius: 5)
                .padding(.bottom, 20)
                
                Text(Output)
                    .frame(maxWidth: .infinity, alignment: .leading) // This makes the text left-aligned within a full-width container
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.purple, lineWidth: 2)
                    )
                    .padding(.bottom, 20)
                
                
                NavigationLink(
                    destination: TranslationsView(),
                    isActive: $Navigate,
                    label: { EmptyView()}
                )
                Button("View Translations"){
                    print("nav button pressed")
                    Navigate.self = true
                    
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5.0))
                .tint(.purple)
                .shadow(radius: 5)
                .padding(.bottom, 20)
                
            }
            .navigationDestination(for: Translation.self) {_ in
                TranslationsView()
            }
        }
        //https://opentdb.com/api.php?amount=10&category=10&difficulty=medium&type=multiple
    }
    func translateMessage() async{
        var url = URLComponents(string: "https://api.mymemory.translated.net/get?")!
        var components = [URLQueryItem(name: "q",  value: "\(Input)")]
        components.append(URLQueryItem(name: "langpair", value: "en|it"))
        url.queryItems = components
        
        do{
            let urlItem = URL(string: url.url!.absoluteString)!
            let (data, _) = try await URLSession.shared.data(from: urlItem)
            let translation = Translation.fromMyMemoryResponse(data)
            let original = translation?.originalText ?? "error"
            let translated = translation?.translatedText ?? "error"
            manager.sendTranslations(original: original, translated: translated)
            Output.self = translated
        } catch {
            print("problem in translateMessage")
        }
    }
}

#Preview {
    ContentView()
}
