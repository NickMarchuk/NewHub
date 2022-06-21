//
//  WebViewController.swift
//  NewsHub
//
//  Created by Nick M on 12.06.2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
// MARK: - CUSTOM PROPERTIES
    var webView: WKWebView!
    var urlString = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let myURL = URL(string: urlString) else {return}
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
}
