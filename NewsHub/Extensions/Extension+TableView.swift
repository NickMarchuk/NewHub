//
//  Extension+TableView.swift
//  NewsHub
//
//  Created by Nick M on 12.06.2022.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource{
        
    // MARK: - TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsViewCell
        
        cell.delegate = self
        cell.indexRow = indexPath.row
        
        let article = articlesList[indexPath.row]
        
        let dataID = article.id
        cell.newsId = dataID
        cell.title = article.title
        cell.descript = article.descript
        cell.source = article.sourceName
        cell.author = article.author
        cell.indicator.startAnimating()
        cell.image = nil

        if article.isFavorite {
            cell.addToFavoriteListButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }else{
            cell.addToFavoriteListButton
                .setImage(UIImage(systemName: "star"), for:  .normal)
        }
        
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
        performSegue(withIdentifier: K.toWebVC, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - SCROLL VIEW
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let y = scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom
        let h = scrollView.contentSize.height

        let distance = CGFloat(20.0)
        if y > h + distance {
            
            if self.articlesList.count < 100{
                refreshBottom.startAnimating()
                self.page += 1
                self.lastQuery = UserDefaults.standard.string(forKey: K.lastQuery) ?? ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.newsService.requestNewsData(self.lastQuery + "&page=\(self.page)") { articles, _ in
                        self.articlesList += articles
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.tableView.refreshControl?.endRefreshing()
                            self.refreshBottom.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - PREPARE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.toWebVC{
            guard let webVC = segue.destination as? WebViewController else{return}
            if let row = tableView.indexPathForSelectedRow?.row{
                webVC.urlString = articlesList[row].url
            }
        } else if segue.identifier == "toFilterVC"{
            guard let filterVC = segue.destination as? FilterTableVC else{return}
            filterVC.delegate = self
            filterVC.nameCell = nameCell
        }
    }
}
