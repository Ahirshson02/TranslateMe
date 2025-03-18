//
//  TranslationManager.swift
//  Unit6-Project-TranslateMe
//
//  Created by Debbie Hirshson on 3/17/25.
//

import Foundation
import FirebaseFirestore

@Observable
class TranslationManager{
    var translations: [Translation] = []
    
    private let dataBase = Firestore.firestore()
    
    init(){
        getTranslations()
    }
    
    func getTranslations() {
        dataBase.collectionGroup("translations").addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else {
                print("error fetching documents \(String(describing: error))")
                return
            }
            let translations = documents.compactMap { document in
                do {
                    return try document.data(as: Translation.self)
                }catch {
                    print("error in decoding document: in getTranslations")
                    return nil
                }
            }
            self.translations = translations.sorted(by: { $0.timestamp < $1.timestamp})
        }
    }
    
    func sendTranslations(original: String, translated: String){
        do {
            let translation = Translation(id: UUID().uuidString, originalText: original, translatedText: translated, timestamp: Date())
            try dataBase.collection("translations").document().setData(from: translation)
        } catch {
            print("Error sending translation to DB: \(String(describing: error))")
        }
    }
    func deleteTranslations(){
        dataBase.collectionGroup("translations").getDocuments() { querySnapshot, error in
            let dispatcherGroup = DispatchGroup()
            guard let documents = querySnapshot?.documents else {
                print("error fetching documents \(String(describing: error))")
                return
            }
            
            for document in documents {
                dispatcherGroup.enter()
                
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting document \(document.documentID): \(error)")
                    } else {
                        print("Document \(document.documentID) successfully deleted")
                    }
                    
                dispatcherGroup.leave()
                }
            }
        }
    }
}
