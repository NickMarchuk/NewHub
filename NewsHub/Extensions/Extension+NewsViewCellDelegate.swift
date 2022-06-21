//
//  Extension+NewsViewCellDelegate.swift
//  NewsHub
//
//  Created by Nick M on 14.06.2022.
//

import Foundation

extension ViewController: NewsViewCellDelegate{
    
    func reloadNews(_ articleList: [ArticlesList]) {
        self.articlesList = articleList
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
