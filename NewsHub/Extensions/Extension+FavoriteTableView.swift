//
//  Extension+FavoriteTableView.swift
//  NewsHub
//
//  Created by Nick M on 13.06.2022.
//

import UIKit

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsViewCell
        
        let article = favoriteArticles[indexPath.row]
        let dataID = article.id
        cell.newsId = dataID
        cell.title = article.title
        cell.descript = article.descript
        cell.source = article.sourceName
        cell.author = article.author
        cell.indicator.startAnimating()
        cell.image = nil
        
        newsService.image(article.urlToImage) { dataImage in
            if let dataImage = dataImage {
                DispatchQueue.main.async {
                    if cell.newsId == dataID{
                        cell.image = UIImage(data: dataImage)
                        cell.indicator.stopAnimating()
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.favoriteVCToWebCV, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - PREPARE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.favoriteVCToWebCV{
            guard let webVC = segue.destination as? WebViewController else{return}
            if let row = tableView.indexPathForSelectedRow?.row{
                webVC.urlString = favoriteArticles[row].url
            }
        }
    }
    
}
