//
//  Translation.swift
//  Unit6-Project-TranslateMe
//
//  Created by Debbie Hirshson on 3/17/25.
//

import Foundation

struct Translation: Hashable, Identifiable, Codable {
    let id: String
    let originalText: String //original text
    let translatedText: String
    let timestamp: Date
    
    static func fromMyMemoryResponse(_ responseData: Data) -> Translation? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: responseData) as? [String: Any],
                  let responseDataDict = json["responseData"] as? [String: Any],
                  let translatedText = responseDataDict["translatedText"] as? String,
                  let matches = json["matches"] as? [[String: Any]],
                  !matches.isEmpty,
                  let originalText = matches[0]["segment"] as? String else {
                return nil
            }
            
            return Translation(id: UUID().uuidString, originalText: originalText, translatedText: translatedText, timestamp: Date())
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
}

extension Translation {
    static var mocked: Translation{
        let jsonUrl = Bundle.main.url(forResource: "mockData", withExtension: "json")!
        let data = try! Data(contentsOf: jsonUrl)
        let trivia = try! JSONDecoder().decode(Translation.self, from: data)
        return trivia
    }
}
