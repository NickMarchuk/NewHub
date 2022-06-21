//
//  NewsViewCell.swift
//  NewsHub
//
//  Created by Nick M on 12.06.2022.
//

import UIKit

protocol NewsViewCellDelegate {
    func favoriteWasPressed(_ button: UIButton, _ indexRow: Int)
}

class NewsViewCell: UITableViewCell {
    
    // MARK: - IBOUTLET PROPERTIES
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageNews: UIImageView!
    @IBOutlet private weak var titleNews: UILabel!
    @IBOutlet private weak var descriptionNews: UILabel!
    @IBOutlet private weak var sourceNews: UILabel!
    @IBOutlet private weak var authorNews: UILabel!
    @IBOutlet weak var addToFavoriteListButton: UIButton!
    
    // MARK: - CUSTOM PROPERTIES
    var newsId = ""
    var indexRow = 0
    var delegate:NewsViewCellDelegate?
    let dbManager = DBManager()
    
    var author: String? {
        didSet{
            authorNews.text = author
        }
    }
    
    var source: String? {
        didSet{
            sourceNews.text = source
        }
    }
    
    var descript: String? {
        didSet{
            descriptionNews.text = descript
        }
    }
    
    var title: String? {
        didSet{
            titleNews.text = title
        }
    }
    
    var image: UIImage? {
        didSet {
            imageNews.image = image
        }
    }
    
    // MARK: - ACTION BUTTONS
    @IBAction func pressedFavoriteButton(_ sender: UIButton) {
        delegate?.favoriteWasPressed(sender, indexRow)
    }
    
    override func layoutSubviews() {
        addToFavoriteListButton.tintColor = .systemRed
        addToFavoriteListButton.setTitle("", for: .normal)
    }
    
}

