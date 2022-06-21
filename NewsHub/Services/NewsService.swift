//
//  NewsService.swift
//  NewsHub
//
//  Created by Nick M on 11.06.2022.
//

import Foundation

class NewsService{
    
// MARK: - CUSTOM PROPERTIES
    private var images = NSCache<NSString,NSData>()

    
// MARK: - REQUEST SOURCES
    func requestSourceList(handler: @escaping (Sources) -> Void){
        let urlString = "https://newsapi.org/v2/top-headlines/sources?apiKey="+K.api
        guard let url = URL(string: urlString)else{return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Session error:", error.localizedDescription)
                return
            }
            if let data = data {
                do {
                    let recivedData = try JSONDecoder().decode(Sources.self, from: data)
                    handler(recivedData)
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
            
        }.resume()
    }
    
// MARK: - REQUEST NEWS
    func requestNewsData(_ stringRequestPart: String, handler: @escaping ([ArticlesList], NewsData?) -> Void){
        let urlString = "https://newsapi.org/v2/"+stringRequestPart+"&apiKey="+K.api
        guard let url = URL(string: urlString)else{return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Session error:", error.localizedDescription)
                return
            }
            if let data = data {
                do {
                    let recivedData = try JSONDecoder().decode(NewsData.self, from: data)
                    var articles = Array<ArticlesList>()
                    for item in recivedData.articles {
                        articles.append(ArticlesList(
                            id: item.id ?? "",
                            sourceName: item.source.name,
                            author: item.author ?? "",
                            title: item.title,
                            descript: item.description ?? "",
                            url: item.url,
                            urlToImage: item.urlToImage ?? "",
                            isFavorite: false))
                    }
                    handler(articles, recivedData)
                }catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }.resume()
        
    }
    
// MARK: - REQUEST IMAGE
    func image(_ imageUrlStr: String, handler: @escaping (Data?) -> Void){
        
        if let image = images.object(forKey: imageUrlStr as NSString){
            handler(image as Data)
            return
        }
        
        guard let url = URL(string: imageUrlStr)else{return}
                
        URLSession.shared.downloadTask(with: url) { sessionUrl, responce, error in
            if let error = error {
                print("Session image error:", error.localizedDescription)
                return
            }
            
            if let sessionUrl = sessionUrl {
                do {
                    let image = try Data(contentsOf: sessionUrl)
                    self.images.setObject(image as NSData, forKey: imageUrlStr as NSString)
                    handler(image)
                }catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
 
        }.resume()
    }
    
}
