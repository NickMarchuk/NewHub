//
//  FavoriteList.swift
//  NewsHub
//
//  Created by Nick M on 13.06.2022.
//

import Foundation
import CoreData

@objc(FavoriteList)
class FavoriteList: NSManagedObject{
    
}

extension FavoriteList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteList> {
        return NSFetchRequest<FavoriteList>(entityName: "FavoriteList")
    }

    @NSManaged public var favoriteNews: ArticlesList?
    @NSManaged public var isFavor: Bool

}

extension FavoriteList : Identifiable {

}
