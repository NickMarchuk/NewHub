//
//  FavoriteCV.swift
//  NewsHub
//
//  Created by Nick M on 13.06.2022.
//

import UIKit

class FavoriteVC: UIViewController {
    
    // MARK: - CUSTOM PROPERTIES
    var tableView: UITableView!
    let dbManager = DBManager()
    let newsService = NewsService()
    var favoriteArticles = Array<ArticlesList>()
    
    // MARK: - VC LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsOfTableView()
        readDataFromDB()
    }
    
    // MARK: - REQUESTS
    fileprivate func readDataFromDB() {
        dbManager.readData() { favList, _, error in
            guard let articlesList = favList else { return }
            self.favoriteArticles = articlesList
        }
    }

    // MARK: - SETTING OF ELEMENTS
        fileprivate func settingsOfTableView() {
            let originOfTableView = CGPoint(x: 0, y: 0)
            let sizeOfTableView = CGSize(width: view.frame.size.width, height: view.frame.size.height)
            tableView = UITableView(frame: CGRect(origin: originOfTableView, size: sizeOfTableView))
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            view.addSubview(tableView)
            tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "cell")
        }

}
