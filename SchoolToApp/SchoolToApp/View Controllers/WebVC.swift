//
//  WebVC.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//

import UIKit
import WebKit

class WebVC: UIViewController {
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var webViewTitleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var pageTitle = ""
    var htmlFileName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewTitleLabel.text = pageTitle
    
        if let filePath = Bundle.main.url(forResource: htmlFileName, withExtension: "html") {
          let request = NSURLRequest(url: filePath)
          webView.load(request as URLRequest)
        }

    }
    

}
