//
//  TranslationsView.swift
//  Unit6-Project-TranslateMe
//
//  Created by Debbie Hirshson on 3/17/25.
//

import SwiftUI

struct TranslationsView: View{
   // @Environment(TranslationManager.self) var manager
    @State var manager: TranslationManager
    
    init(){
        manager = TranslationManager()
    }
    
    var body: some View{
        ZStack{
            Color(Color.purple)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Trivia Game")
                    .font(.system(size: 42))
                    .bold()
                    .foregroundStyle(Color.white)
                
                List{
                    LazyVStack{
                        Rectangle()
                            .stroke(style: StrokeStyle(lineWidth: 2))
                            .foregroundStyle(.purple)
                            .frame(height: 1)
                        ForEach(manager.translations){ translation in
                            TextView(translated: translation.translatedText, original: translation.originalText)
                        }
                    }
                }
                Button {
                    manager.deleteTranslations()
                    
                    print("Deleted Translations")
                } label: {
                    Text("Delete Saved Translations")
                }
                .disabled(manager.translations.isEmpty)
                .font(.system(size: 24))
                .bold()
                .padding()
                .frame(maxWidth: 350, maxHeight: 40)
                .background(Color.red)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
            }
                
        }
    }
}
struct TextView: View {
    let translated: String
    let original: String
    var body: some View{
        HStack{
            Text(original)
                .font(.system(size: 17, weight: .medium))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
            
            Image(systemName: "arrow.forward")
                .font(.system(size: 14))
                .foregroundColor(.blue)
            
            Text(translated)
                .font(.system(size: 17, weight: .medium))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
        }
        Rectangle()
            .stroke(style: StrokeStyle(lineWidth: 2))
            .foregroundStyle(.purple)
            .frame(height: 1)
    }
}
#Preview {
    TranslationsView()
}
