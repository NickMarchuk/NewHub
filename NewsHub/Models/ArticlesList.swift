//
//  FavoriteArticles.swift
//  NewsHub
//
//  Created by Nick M on 13.06.2022.
//

import UIKit

class ArticlesList: NSObject, NSCoding{
    
    var id: String = ""
    var sourceName: String = ""
    var author: String = ""
    var title: String = ""
    var descript: String = ""
    var url: String = ""
    var urlToImage: String = ""
    var isFavorite: Bool = false
    
    init(id: String, sourceName: String, author: String, title: String, descript: String, url: String, urlToImage: String, isFavorite: Bool) {
        self.id = id
        self.sourceName = sourceName
        self.author = author
        self.title = title
        self.descript = descript
        self.url = url
        self.urlToImage = urlToImage
        self.isFavorite = isFavorite
    }

    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: "id")
        coder.encode(self.sourceName, forKey: "sourceName")
        coder.encode(self.author, forKey: "author")
        coder.encode(self.title, forKey: "title")
        coder.encode(self.descript, forKey: "descript")
        coder.encode(self.url, forKey: "url")
        coder.encode(self.urlToImage, forKey: "urlToImage")
        coder.encode(self.isFavorite, forKey: "isFavorite")
    }
    
    required init?(coder: NSCoder) {
        self.id = coder.decodeObject(forKey: "id") as? String ?? ""
        self.sourceName = coder.decodeObject(forKey: "sourceName")  as? String ?? ""
        self.author = coder.decodeObject(forKey: "author") as? String ?? ""
        self.title = coder.decodeObject(forKey: "title") as? String ?? ""
        self.descript = coder.decodeObject(forKey: "descript") as? String ?? ""
        self.url = coder.decodeObject(forKey: "url") as? String ?? ""
        self.urlToImage = coder.decodeObject(forKey: "urlToImage") as? String ?? ""
        self.isFavorite = coder.decodeObject(forKey: "isFavorite") as? Bool ?? false
    }
}
