//
//  ViewController.swift
//  NewsHub
//
//  Created by Nick M on 11.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOUTLET PROPERTIES
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var savedVCButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - CUSTOM PROPERTIES
    var refreshControl = UIRefreshControl()
    var refreshBottom = UIActivityIndicatorView()
    var tableView: UITableView!
    let showFileringButtons = UIButton(type: .system)
    let filterButtons = [UIButton(type: .system),UIButton(type: .system),UIButton(type: .system)]
    let filterView = UIView()
    
    let dbManager = DBManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let newsService = NewsService()
    
    var articlesList = Array<ArticlesList>()
    var favoriteList = Array<ArticlesList>()
    var urlString:String?
    var nameCell = ""
    var lastQuery = ""
    var closeFiltering = false
    var page = 1
    var headOfTableView:CGFloat = 0
    var sizeFilterButton:CGFloat = 0
    var viewWidth:CGFloat = 0
    var viewHeight:CGFloat = 0
    var topSafeArea:CGFloat = 0
    var bottomSafeArea:CGFloat = 0
    
    // MARK: - VC LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        firstStart()
        requestFreshNews()
        readDataFromDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBasicSizes()
        configureTableView()
        configureSearchButton()
        configureRefreshControl()
        configureFiltering()
        configureBottomRefresh()
    }
    
    // MARK: - ACTION BUTTONS
    @IBAction func pressedSavedVCButton(_ sender: UIButton) {
        performSegue(withIdentifier: K.toFavoriteVC, sender: self)
    }
    
    @IBAction func pressedSearchButton(_ sender: UIButton) {
        if searchBar.text != "" { searchBar.endEditing(true) }
    }
    
    // MARK: - REQUESTS
    fileprivate func firstStart() {
        if !UserDefaults.standard.bool(forKey: K.firstLaunch){
            UserDefaults.standard.set(true, forKey: K.firstLaunch)
            UserDefaults.standard.set(K.everythingQ + "a", forKey: K.lastQuery)
        }
    }
    
    fileprivate func requestFreshNews() {
        lastQuery = UserDefaults.standard.string(forKey: K.lastQuery) ?? ""
        
        newsService.requestNewsData(lastQuery) { articles, _ in
            self.articlesList = articles
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func readDataFromDB() {
        dbManager.readData(context) { favorList, _, error in
            guard let _ = error else { return }
            guard let favorList = favorList else { return }
            self.favoriteList = favorList
        }
    }
    
    // MARK: - SETTING OF ELEMENTS
    
    // MARK: CONFIGURE BASIC SIZE
    fileprivate func configureBasicSizes(){
        viewWidth = view.frame.size.width
        viewHeight = view.frame.size.height
        topSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        bottomSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    }
    
    // MARK: CONFIGURE FILTER VIEW
    fileprivate func configureFiltering(){
        
        let yPosition = viewHeight - bottomSafeArea - topSafeArea - 8
        
        showFileringButtons.frame.size = CGSize(width: 50, height: 50)
        showFileringButtons.frame.origin = CGPoint(x: -showFileringButtons.frame.size.width, y: yPosition)
        showFileringButtons.setImage(UIImage(systemName: "list.bullet.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        showFileringButtons.tintColor = .systemGray
        view.addSubview(showFileringButtons)
        
        UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseOut) {
            self.showFileringButtons.frame.origin = CGPoint(x: 24, y: yPosition)
        }
        
        showFileringButtons.addTarget(self, action: #selector(showFilterView), for: .touchUpInside)
        
        filterView.frame.size = CGSize(width: 0, height: showFileringButtons.frame.height)
        filterView.frame.origin = CGPoint(x: showFileringButtons.frame.origin.x + showFileringButtons.frame.size.width, y: showFileringButtons.frame.origin.y)
        view.addSubview(filterView)
        
    }
    
    @objc fileprivate func showFilterView(){
        if closeFiltering{
            self.showFileringButtons.setImage(UIImage(systemName: "list.bullet.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
                self.filterView.frame.size = CGSize(width: 0, height: self.showFileringButtons.frame.height)
                for favoriteButton in self.filterButtons{
                    favoriteButton.frame.size.width = 0
                    favoriteButton.frame.origin.x = 0
                }
            } completion: { _ in
                
            }
        }else{
            showFileringButtons.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {
                self.filterView.frame.size = CGSize(width: self.viewWidth / 1.5, height: self.showFileringButtons.frame.height)
                self.sizeFilterButton = self.filterView.frame.size.width / 3
                self.configureFilterButtons()
            } completion: { _ in
                
            }
        }
        closeFiltering.toggle()
    }
    
    // MARK: CONFIGURE FILTER BUTTONS
    fileprivate func configureFilterButtons() {
        for (indexButton,filterButton) in filterButtons.enumerated() {
            filterButton.frame.origin.y = 0
            filterButton.frame.size = CGSize(width: filterView.frame.size.width / 3.3, height: filterView.frame.size.height)
            filterButton.backgroundColor = .systemGreen
            //                filterButton.titleLabel?.textColor = .white
            filterButton.tintColor = .white
            filterButton.layer.cornerRadius = showFileringButtons.frame.width / 2
            if indexButton == 0{
                filterButton.frame.origin.x = 0
                filterButton.setTitle("Category", for: .normal)
                filterButton.addTarget(self, action: #selector(pressedCategoryButton), for: .touchUpInside)
            }else if indexButton == 1{
                filterButton.frame.origin.x = sizeFilterButton
                filterButton.setTitle("Countries", for: .normal)
                filterButton.addTarget(self, action: #selector(pressedCountriesButton), for: .touchUpInside)
            }else{
                filterButton.frame.origin.x = sizeFilterButton * 2
                filterButton.setTitle("Sources", for: .normal)
                filterButton.addTarget(self, action: #selector(pressedSourcesButton), for: .touchUpInside)
            }
            filterView.addSubview(filterButton)
        }
    }
    
    @objc fileprivate func pressedCategoryButton(){
        nameCell = K.categoryCell
        performSegue(withIdentifier: K.toFilterVC, sender: self)
    }
    @objc fileprivate func pressedCountriesButton(){
        nameCell = K.countryCell
        performSegue(withIdentifier: K.toFilterVC, sender: self)
    }
    @objc fileprivate func pressedSourcesButton(){
        nameCell = K.sourceCell
        performSegue(withIdentifier: K.toFilterVC, sender: self)
    }
    
    // MARK: CONFIGURE REFRESH CONTROL
    fileprivate func configureRefreshControl() {
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(refrechTable), for: .valueChanged)
    }
    
    @objc func refrechTable(){
        self.lastQuery = UserDefaults.standard.string(forKey: K.lastQuery) ?? ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.newsService.requestNewsData(self.lastQuery) { articles, _ in
                self.articlesList = articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.page = 1
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    fileprivate func configureBottomRefresh() {
        refreshBottom = UIActivityIndicatorView(style: .large)
        refreshBottom.hidesWhenStopped = true
        refreshBottom.frame.size = CGSize(width: viewWidth, height: 80)
        refreshBottom.frame.origin = CGPoint(x: 0, y: 0)
        tableView.tableFooterView = refreshBottom
        refreshBottom.stopAnimating()
    }
    
    // MARK: CONFIGURE TABLE VIEW
    fileprivate func configureTableView() {
        let originOfTableView = CGPoint(x: 0, y: headerView.frame.size.height + topSafeArea)
        let sizeOfTableView = CGSize(width: viewWidth, height: viewHeight - topSafeArea - headerView.frame.size.height - bottomSafeArea)
        tableView = UITableView(frame: CGRect(origin: originOfTableView, size: sizeOfTableView))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    // MARK: CONFIGURE SEARCH BUTTON
    fileprivate func configureSearchButton() {
        searchBar.delegate = self
        savedVCButton.setImage(UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        savedVCButton.tintColor = .systemOrange
        
        searchButton.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        searchButton.tintColor = .systemGray
        searchButton.setTitle("", for: .normal)
    }
    
}

