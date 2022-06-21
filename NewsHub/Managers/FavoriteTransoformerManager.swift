//
//  FavoriteTransoformerManager.swift
//  NewsHub
//
//  Created by Nick M on 13.06.2022.
//

import Foundation

class FavoriteTransoformerManager: ValueTransformer{
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let favorArticle = value as? ArticlesList else { return nil }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: favorArticle, requiringSecureCoding: true)
        } catch {
            print("Problem with secure coding:", error.localizedDescription)
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            
           return try NSKeyedUnarchiver.unarchivedObject(ofClass: ArticlesList.self, from: data)

        } catch {
            print("Problem with secure coding:", error.localizedDescription)
            return nil
        }
    }
    
}
