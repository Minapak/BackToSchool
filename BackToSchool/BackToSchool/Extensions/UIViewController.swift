//
//  UIViewController.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//

import UIKit


var vSpinner : UIView?

extension UIViewController {
    
    /// Show android like toast mrssage
    /// - Parameters:
    ///   - message: String
    ///   - isOnTop: Bool
    func showToast(message : String, isOnTop: Bool = false) {
        var yPosition: CGFloat = 100
        if !isOnTop {
            yPosition = UIScreen.main.bounds.size.height - 100//self.view.frame.size.height
        }
        let toastLabel = UILabel(frame: CGRect(x: 10, y: yPosition, width: self.view.frame.size.width-20, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.numberOfLines = 3
        toastLabel.clipsToBounds  =  true
        ///self.view.addSubview(toastLabel)
        let window = UIApplication.shared.keyWindow!
        window.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    /// Show alert dialog
    /// - Parameters:
    ///   - title: String
    ///   - message: String
    func showAlertDialog(title:String?, message:String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Show a undetermined loading view with a text
    ///
    /// - Parameter message: String
    func showLoadingViewOnTop(message: String) {

    }
    
    /// Show a undetermined loading view
    func showLoadingView() {

    }
    
    /// Hide the loading view which is showing
    func hideLoadingView() {
        DispatchQueue.main.async {
            if AppUtils.loadingViewParent != nil {
                AppUtils.loadingViewParent?.removeFromSuperview()
                AppUtils.loadingViewParent = nil
            }
        }
    }
    
    /// Ser Navigation bar
    /// - Parameter imageName: String
    func setNavigationBar(imageName:String) {
        
        self.navigationItem.setHidesBackButton(true, animated:false)
        
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let imageView = UIImageView(frame: CGRect(x: -10, y: 10, width: 25, height: 25))
        
        if let imgBackArrow = UIImage(named: imageName) {
            imageView.image = imgBackArrow
        }
        view.addSubview(imageView)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backToMain))
        view.addGestureRecognizer(backTap)
        
        let leftBarButtonItem = UIBarButtonItem(customView: view )
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func backToMain() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Return the actual class name
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    
    
    /// Show a spinner
    /// - Parameter onView: view
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.4)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.color = UIColor.orange
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    
    /// Remove spinner
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
}
