//
//  Extension+SearchBar.swift
//  NewsHub
//
//  Created by Nick M on 14.06.2022.
//

import UIKit

extension ViewController: UISearchBarDelegate{
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text != ""{
            DispatchQueue.main.async {
                let urlPart = K.everythingQ + (searchBar.text ?? "")
                UserDefaults.standard.set(urlPart, forKey: K.lastQuery)
                self.newsService.requestNewsData(urlPart) { articles, _ in
                    print(articles.count)
                    self.articlesList = articles
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        searchBar.resignFirstResponder()
                    }
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}
