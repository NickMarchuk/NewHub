//
//  NewsData.swift
//  NewsHub
//
//  Created by Nick M on 11.06.2022.
//

import Foundation

struct NewsData: Codable{
    
    let status: String
    let totalResults: Int?
    let articles: [Articles]
}

class Articles: Codable, Identifiable{
    
    public var id:String? { title }
    let source: Source
    let author: String?
    let title: String
    var description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source: Codable{
    
    let id: String?
    let name: String
    
}

struct Sources: Codable{
    let sources: [Source]?
}


