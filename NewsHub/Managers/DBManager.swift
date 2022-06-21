//
//  DBManager.swift
//  NewsHub
//
//  Created by Nick M on 13.06.2022.
//

import UIKit
import CoreData

class DBManager{
    
    func saveData(_ context: NSManagedObjectContext) {
        if context.hasChanges{
            do {
                try context.save()
                print("SAVED!")
            } catch {
                print("Problem with saving in core data: ",error.localizedDescription)
            }
        }
    }
    
    func readData(_ context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext, handler: @escaping ([ArticlesList]?, [String]?, Error?) -> Void) {
        let fetchRequest: NSFetchRequest<FavoriteList> = FavoriteList.fetchRequest()
        do{
            let fav = try context.fetch(fetchRequest)
            var arts = Array<ArticlesList>()
            var ids = Array<String>()
            for item in fav {
                if let news = item.favoriteNews{
                    arts.append(news)
                    ids.append(news.id)
                }
            }
            handler(arts,ids,nil)
        }catch{
            handler(nil,nil,error)
        }
    }
    
}
