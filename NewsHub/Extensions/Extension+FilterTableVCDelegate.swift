//
//  Extension+FilterTableVCDelegate.swift
//  NewsHub
//
//  Created by Nick M on 14.06.2022.
//

import UIKit

extension ViewController: FilterTableVCDelegate{
    
    func favoriteWasPressed(_ button: UIButton, _ indexRow: Int) {
        
        dbManager.readData(context) { _ , ids, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let ids = ids else { return }
            
            if !ids.contains(self.articlesList[indexRow].id){
                let favList = FavoriteList(context: self.context)
                favList.favoriteNews = self.articlesList[indexRow]
                favList.favoriteNews?.isFavorite = true
                self.dbManager.saveData(self.context)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
        
    }
}
