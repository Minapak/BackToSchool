//
//  EditProfileVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//


import UIKit
import SwiftyJSON
import MBProgressHUD
import Alamofire

class EditProfileVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    
    //MARK: Variables
    let imagePicker = UIImagePickerController()
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgProfile.layer.cornerRadius = 75.0
        self.btnSelectImage.layer.cornerRadius = 25.0
        self.btnUpdate.layer.cornerRadius = 8.0
        
        let urlString = API_URL + "getprofile.php"
        let params: NSDictionary = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String]
        self.Webservice_GetProfile(url: urlString, params: params)
        
    }
    
}

//MARK: Actions
extension EditProfileVC {
    @IBAction func btnBack_Clicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectImage_Clicked(_ sender: UIButton) {
        self.imagePicker.delegate = self
        let alert = UIAlertController(title: Bundle.main.displayName!, message: "프로필 이미지 선택", preferredStyle: .actionSheet)
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
    
    @IBAction func btnUpdate_Clicked(_ sender: UIButton) {
        if self.txtUsername.text! == "" {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "모든 칸을 채워주세요")
        }
        else {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "이름과 이메일은 바뀌지 않습니다")
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let imageData = self.imgProfile.image!.jpegData(compressionQuality: 0.5)
            let urlString = API_URL + "editprofile.php"
            let params = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                          "username":self.txtUsername.text!,
                          "profile_image":imageData!] as [String : Any]

             let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
            WebServices().multipartWebService(method:.post, URLString:urlString, encoding:JSONEncoding.default, parameters:params, fileData:imageData!, fileUrl:nil, headers:headers, keyName:"profile_image") { (response, error) in
                
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
                        self.navigationController?.popViewController(animated: true)
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
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imgProfile.image = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Webservices
extension EditProfileVC {
    func Webservice_GetProfile(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["ResponseCode"].stringValue
                if responseCode == "1" {
                    let responseData = jsonResponse!["ResponseData"].dictionaryValue
                    self.imgProfile.sd_setImage(with: URL(string: responseData["profile_image"]!.stringValue), placeholderImage: UIImage(named: "placeholder_image"))
                    self.txtUsername.text = responseData["username"]?.stringValue
                    self.txtEmail.text = responseData["email"]?.stringValue
                }
            }
        }
    }
}
