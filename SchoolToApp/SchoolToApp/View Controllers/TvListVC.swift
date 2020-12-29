//
//  TvListVC.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//

// https://medium.com/@NickBabo/equally-spaced-uicollectionview-cells-6e60ce8d457b

import UIKit

class TvListVC: UIViewController {
    @IBOutlet weak var channelTitleBarLabel: UILabel!
    @IBOutlet weak var searchBarView: UIView!
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var liveTvChannelCollectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    var liveTVList = [LiveTvObject]()
    var pagination = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI Collection view layout
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        //Get device width
        let width = UIScreen.main.bounds.width
        
        //set section inset as per your requirement.
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        //set cell item size here
        layout.itemSize = CGSize(width: width / 3, height: width / 3)
        
        //set Minimum spacing between 2 items
        layout.minimumInteritemSpacing = 5
        
        //set minimum vertical line spacing here between two lines in collectionview
        layout.minimumLineSpacing = 10
        
        //apply defined layout to collectionview
        liveTvChannelCollectionView!.collectionViewLayout = layout
        
        
        self.view.layoutIfNeeded()
        self.searchBarView.layer.cornerRadius = self.searchBarView.frame.height/2
        self.searchBarView.layer.borderWidth = 1
        self.searchBarView.layer.borderColor = UIColor.orange.cgColor
        self.searchBarView.layer.masksToBounds  = true
        
        self.showSpinner(onView: self.view)
        getLiveTvDataFromServer()
    }
    
    // 2
    private func getLiveTvDataFromServer() {
        
        DispatchQueue.global().async {
            VideonManager.shared().getLiveTvListData(pageValue: self.pagination) { (dataList, message) in
                DispatchQueue.main.async {
                    self.removeSpinner()
                    if dataList != nil {
                        self.liveTVList = dataList
                        self.liveTvChannelCollectionView.reloadData()
                        
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
        }
    }
    
}
extension TvListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return liveTVList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvCell", for: indexPath) as! LiveTVCell
        
        let liveTv = liveTVList [indexPath.item]
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.thumbUrl + liveTv.imageName
        // showCategoryImage uses square shapped placeholder image
        cell.imageView.showCategoryImage(path: url)
        cell.titleLabel.text = liveTv.title
        
        
        return cell
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 115, height: 135 )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToNextViewController()
    }
    
    func goToNextViewController()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToNextViewControllerWith(videoObject:VideoObject)
    {
        print(videoObject)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        vc.videoObject = videoObject
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToVideoListController(categoryObject:CategoryObject)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoListVC") as! VideoListVC
        vc.categoryValue = Int(categoryObject.id) ?? 0
        vc.titleLabelText = categoryObject.title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

