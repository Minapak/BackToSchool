//
//  AddWallpaperVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit
import DropDown
import SwiftyJSON
import Alamofire
import MBProgressHUD

class AddWallpaperVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var viewWallpapername: UIView!
    @IBOutlet weak var txtWallpapername: UITextField!
    @IBOutlet weak var imgWallpaper: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    
    //MARK: Variables
    var categoryId = ""
    var imageHeight = 0
    var imageColor = ""
    let imagePicker = UIImagePickerController()
    var categoryArr = [[String:String]]()
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnUpload.layer.cornerRadius = 8.0
        self.viewCategory.layer.cornerRadius = 5.0
        self.viewWallpapername.layer.cornerRadius = 5.0
        self.imgWallpaper.layer.cornerRadius = 5.0
        self.imgWallpaper.image = #imageLiteral(resourceName: "upload_image")
        
        let urlString = API_URL + "getcategories.php"
        self.Webservice_Categories(url: urlString)
    }
    
}

//MARK: Actions
extension AddWallpaperVC {
    @IBAction func btnBack_Clicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectCategory_Clicked(_ sender: UIButton) {
        var categoryNameArr = [String]()
        for category in categoryArr {
            categoryNameArr.append(category["category_name"]!)
        }
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: 50.0)
        dropDown.width =  UIScreen.main.bounds.width - 32.0
        dropDown.dataSource = categoryNameArr
        dropDown.selectionAction = {(index, item) in
            self.lblCategory.text = item
            self.categoryId = self.categoryArr[index]["id"]!
        }
        dropDown.show()
    }
    
    @IBAction func btnSelectWallpaper_Clicked(_ sender: UIButton) {
        self.imagePicker.delegate = self
        let alert = UIAlertController(title: Bundle.main.displayName!, message: "수업자료 선택", preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "사진 앨범", style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnUpload_Clicked(_ sender: UIButton) {
        if self.categoryId == "" || self.txtWallpapername.text! == "" || self.imgWallpaper.image! == #imageLiteral(resourceName: "upload_image") {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "모든 칸을 채워주세요")
        }
        else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let imageData = self.imgWallpaper.image!.jpegData(compressionQuality: 0.0)
            let urlString = API_URL + "uploadwallpaper.php"
            let params = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                          "category_id":self.categoryId,
                          "wallpaper_height":"\(self.imageHeight)",
                "name":self.txtWallpapername.text!,
                "wallpaper_color":self.imageColor,
                "wallpaper_image":imageData!] as [String : Any]
//            let header  = ["Content-type": "multipart/form-data"]
            
             let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
            WebServices().multipartWebService(method:.post, URLString:urlString, encoding:JSONEncoding.default, parameters:params, fileData:imageData!, fileUrl:nil, headers:headers, keyName:"wallpaper_image") { (response, error) in
                
                MBProgressHUD.hide(for: self.view, animated: false)
                if error != nil {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: error!.localizedDescription)
                }
                else {
                    print(response!)
                    let responseData = response as! NSDictionary
                    let responseCode = responseData.value(forKey: "ResponseCode") as! NSNumber
                    let responseMsg = responseData.value(forKey: "ResponseMessage") as! String
                    if responseCode == 1 {
                        self.categoryId = ""
                        self.imageColor = ""
                        self.imageHeight = 0
                        self.lblCategory.text = "과목 선택"
                        self.txtWallpapername.text = ""
                        self.imgWallpaper.image = #imageLiteral(resourceName: "upload_image")
                        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: responseMsg)
                    }
                    else {
                        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: responseMsg)
                    }
                }
            }
        }
    }
}

//MARK: Functions
extension AddWallpaperVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imgWallpaper.image = pickedImage
            self.imageHeight = Int(self.imgWallpaper.image!.height(forWidth: 205.0))
            self.imageColor = self.imgWallpaper.image!.averageColor
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Webservices
extension AddWallpaperVC
{
    func Webservice_Categories(url:String) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:[:], httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["ResponseCode"].stringValue
                if responseCode == "1" {
                    let responseData = jsonResponse!["ResponseData"].arrayValue
                    self.categoryArr.removeAll()
                    for data in responseData {
                        let categoryObj = ["id":data["id"].stringValue,"category_image":data["category_image"].stringValue,"category_name":data["category_name"].stringValue]
                        self.categoryArr.append(categoryObj)
                    }
                }
            }
        }
    }
}
