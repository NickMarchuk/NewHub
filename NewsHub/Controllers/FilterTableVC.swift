//
//  FilterTableVC.swift
//  NewsHub
//
//  Created by Nick M on 14.06.2022.
//

import UIKit

//enum NewsCategories: String, CaseIterable{
//    case business = "Business"
//    case entertainment = "Entertainment"
//    case general = "General"
//    case health = "Health"
//    case science = "Science"
//    case sports = "Sports"
//    case technology = "Technology"
//}

protocol FilterTableVCDelegate{
    func reloadNews(_ articleList: [ArticlesList])
}

class FilterTableVC: UITableViewController {

    // MARK: - CUSTOM PROPERTIES
    var nameCell = K.categoryCell
    let newsService = NewsService()
    var delegate: FilterTableVCDelegate?
    var sources = Array<Source>()
    
    // MARK: - VC LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSourceList()
        
    }
    
    // MARK: - REQUESTS
    fileprivate func getSourceList() {
        if nameCell == K.sourceCell{
            newsService.requestSourceList { sour in
                if let sources = sour.sources{
                    self.sources = sources
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: TABLE VIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nameCell == K.categoryCell{
            return StaticData.categoryList.count
        }else if nameCell == K.countryCell{
            return StaticData.countryList.count
        }else if nameCell == K.sourceCell{
            return sources.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: nameCell, for: indexPath)
        
        if cell.reuseIdentifier == K.categoryCell {
            if let categoryCell = cell as? CategoriesCell{
                categoryCell.aName.text = StaticData.categoryList[indexPath.row]
            }
        }else if cell.reuseIdentifier == K.countryCell{
            if let countryCell = cell as? CountriesCell{
                countryCell.aName.text = StaticData.countryList[StaticData.getKeys()[indexPath.row]]
            }
        }else{
            if let sourceCell = cell as? SourcesCell{
                sourceCell.aName.text = sources[indexPath.row].name
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var urlPart = ""
        if nameCell == K.categoryCell{
            urlPart = K.headlinesCategory + StaticData.categoryList[indexPath.row]
            newsService.requestNewsData(urlPart) { articleList, _ in
                self.delegate?.reloadNews(articleList)
            }
        }else if nameCell == K.countryCell{
            urlPart = K.headlinesCountry + StaticData.getKeys()[indexPath.row].lowercased()
            newsService.requestNewsData(urlPart) { articleList, _ in
                self.delegate?.reloadNews(articleList)
            }
        }else{
            urlPart = K.headlinesSources + (sources[indexPath.row].id ?? "")
            newsService.requestNewsData(urlPart) { articleList, _ in
                self.delegate?.reloadNews(articleList)
            }
        }
        UserDefaults.standard.set(urlPart, forKey: K.lastQuery)
        dismiss(animated: true)
    }
}
