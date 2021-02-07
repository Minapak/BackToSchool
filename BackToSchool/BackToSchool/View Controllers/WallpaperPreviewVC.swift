//
//  WallpaperPreviewVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit
import iOSPhotoEditor
import MBProgressHUD
import SwiftyJSON

class PreviewCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgWallpaper: UIImageView!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var btnUserDetail: UIButton!
}

class WallpaperPreviewVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collection_wallpapers: UICollectionView!
    
    //MARK: Variables
    var wallpaperArr = [[String:String]]()
    var wallpaperIndex = IndexPath()
    var isComefrom = 0
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if self.isComefrom == 0 {
            self.collection_wallpapers.scrollToItem(at: self.wallpaperIndex, at: .right, animated: false)
        }
    }
    
}

//MARK: Actions
extension WallpaperPreviewVC {
    @IBAction func btnBack_Clicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnUserDetail_Clicked(sender: UIButton) {
        self.isComefrom = 1
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
        objVC.userId = self.wallpaperArr[sender.tag]["user_id"]!
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @objc func btnDownload_Clicked(sender: UIButton) {
        self.isComefrom = 1
        MBProgressHUD.showAdded(to:self.view, animated:true)
        if let url = URL(string: self.wallpaperArr[sender.tag]["wallpaper_image"]!),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            MBProgressHUD.hide(for:self.view, animated:true)
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "사진앨범에 정상적으로 저장되었습니다.")
        }
    }
    
    @objc func btnShare_Clicked(sender: UIButton) {
        self.isComefrom = 1
        MBProgressHUD.showAdded(to:self.view, animated:true)
        if let url = URL(string: self.wallpaperArr[sender.tag]["wallpaper_image"]!) {
            MBProgressHUD.hide(for:self.view, animated:true)
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.present(activityVC, animated: true)
        }
    }
    
    @objc func btnLike_Clicked(sender: UIButton) {
        self.isComefrom = 1
        if UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" || UserDefaults.standard.value(forKey: UD_userId) as! String == "0" {
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            UIApplication.shared.windows[0].rootViewController = nav
        }
        else {
            if self.wallpaperArr[sender.tag]["isFavourite"] == "2" {
                let urlString = API_URL + "favouriteunfavourite.php"
                let params: NSDictionary = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                                            "wallpaper_id":self.wallpaperArr[sender.tag]["id"]!,
                                            "favourite":"1"]
                self.Webservice_FavouriteUnfavouriteWallpaper(url: urlString, params: params, wallpaperIndex: sender.tag, isFavourite: "1")
            }
            else {
                let urlString = API_URL + "favouriteunfavourite.php"
                let params: NSDictionary = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                                            "wallpaper_id":self.wallpaperArr[sender.tag]["id"]!,
                                            "favourite":"2"]
                self.Webservice_FavouriteUnfavouriteWallpaper(url: urlString, params: params, wallpaperIndex: sender.tag, isFavourite: "2")
            }
        }
    }
    
    @objc func btnEdit_Clicked(sender: UIButton) {
        self.isComefrom = 1
        MBProgressHUD.showAdded(to:self.view, animated:true)
        if let url = URL(string: self.wallpaperArr[sender.tag]["wallpaper_image"]!),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            MBProgressHUD.hide(for:self.view, animated:true)
            let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
            photoEditor.photoEditorDelegate = self
            photoEditor.image = image
            for i in 0...10 {
                photoEditor.stickers.append(UIImage(named: i.description )!)
            }
            photoEditor.modalPresentationStyle = UIModalPresentationStyle.currentContext
            self.present(photoEditor, animated: true, completion: nil)
        }
    }
}

//MARK: Collectionview methods
extension WallpaperPreviewVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.wallpaperArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collection_wallpapers.dequeueReusableCell(withReuseIdentifier: "PreviewCollectionCell", for: indexPath) as! PreviewCollectionCell
        cell.viewUser.layer.cornerRadius = 35.0
        cell.imgUser.layer.cornerRadius = 30.0
        cell.btnDownload.layer.cornerRadius = 25.0
        cell.btnShare.layer.cornerRadius = 25.0
        cell.btnLike.layer.cornerRadius = 25.0
        cell.btnEdit.layer.cornerRadius = 25.0
        cell.contentView.backgroundColor = UIColor(hex: self.wallpaperArr[indexPath.item]["wallpaper_color"]!)
        cell.imgWallpaper.isHidden = true
        cell.imgWallpaper.sd_setImage(with: URL(string: self.wallpaperArr[indexPath.item]["wallpaper_image"]!)) { (image, error, cache, url) in
            cell.imgWallpaper.isHidden = false
        }
        print(self.wallpaperArr[indexPath.item]["user_image"]!)
        cell.imgUser.sd_setImage(with: URL(string: self.wallpaperArr[indexPath.item]["user_image"]!), placeholderImage: UIImage(named: "placeholder_image"))
        cell.lblUser.text = "By " + self.wallpaperArr[indexPath.item]["user_name"]!
        cell.lblCategory.text = self.wallpaperArr[indexPath.item]["category_name"]
        if self.wallpaperArr[indexPath.item]["isFavourite"] == "2" {
            cell.btnLike.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        else {
            cell.btnLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        cell.btnUserDetail.tag = indexPath.item
        cell.btnUserDetail.addTarget(self, action: #selector(self.btnUserDetail_Clicked(sender:)), for: .touchUpInside)
        cell.btnDownload.tag = indexPath.item
        cell.btnDownload.addTarget(self, action: #selector(self.btnDownload_Clicked(sender:)), for: .touchUpInside)
        cell.btnShare.tag = indexPath.item
        cell.btnShare.addTarget(self, action: #selector(self.btnShare_Clicked(sender:)), for: .touchUpInside)
        cell.btnLike.tag = indexPath.item
        cell.btnLike.addTarget(self, action: #selector(self.btnLike_Clicked(sender:)), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.item
        cell.btnEdit.addTarget(self, action: #selector(self.btnEdit_Clicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20.0)
    }
}

//MARK: Functions
extension WallpaperPreviewVC: PhotoEditorDelegate {
    func doneEditing(image: UIImage) {
        print("편집완료")
    }
    
    func canceledEditing() {
        print("편집취소")
    }
    
    func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
}

//MARK: Webservices
extension WallpaperPreviewVC {
    func Webservice_FavouriteUnfavouriteWallpaper(url:String, params:NSDictionary, wallpaperIndex:Int, isFavourite:String) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["ResponseCode"].stringValue
                if responseCode == "1" {
                    let wallpaperObj = ["id":self.wallpaperArr[wallpaperIndex]["id"]!,"wallpaper_image":self.wallpaperArr[wallpaperIndex]["wallpaper_image"]!,"wallpaper_height":self.wallpaperArr[wallpaperIndex]["wallpaper_height"]!,"wallpaper_color":self.wallpaperArr[wallpaperIndex]["wallpaper_color"]!,"user_id":self.wallpaperArr[wallpaperIndex]["user_id"]!,"user_image":self.wallpaperArr[wallpaperIndex]["user_image"]!,"user_name":self.wallpaperArr[wallpaperIndex]["user_name"]!,"wallpaper_likes":self.wallpaperArr[wallpaperIndex]["wallpaper_likes"]!,"wallpaper_views":self.wallpaperArr[wallpaperIndex]["wallpaper_views"]!,"category_name":self.wallpaperArr[wallpaperIndex]["category_name"]!,"isFavourite":isFavourite]
                    self.wallpaperArr.remove(at: wallpaperIndex)
                    self.wallpaperArr.insert(wallpaperObj, at: wallpaperIndex)
                    self.collection_wallpapers.reloadData()
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["ResponseMessage"].stringValue)
                }
            }
        }
    }
}

//fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
//    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
//}
//
//fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
//    return input.rawValue
//}
