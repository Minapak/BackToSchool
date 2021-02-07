//
//  WebviewVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit
import WebKit
import MBProgressHUD
class WebviewVC: UIViewController,WKNavigationDelegate,WKUIDelegate {
    @IBOutlet weak var lbl_title: UILabel!
    var isSelectedindex = String()
    var webUrl = String()
    var setTitle = String()
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if isSelectedindex == "1"
        {
            self.webUrl = Privacy_URL
            self.lbl_title.text = self.setTitle
        }
        else if isSelectedindex == "2"
        {
            self.webUrl = About_URL
            self.lbl_title.text = self.setTitle
        }
        let url = NSURL(string:webUrl)
        let request = URLRequest(url: url! as URL)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.load(request)
    }
    
    @IBAction func btnTap_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
           print(error.localizedDescription)
       }
       func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
           MBProgressHUD.showAdded(to: self.view, animated: true)
       }
       func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           MBProgressHUD.hide(for:self.view, animated: true)
       }
}
