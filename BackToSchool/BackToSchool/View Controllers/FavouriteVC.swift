//
//  FavouriteVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//

import UIKit
import ZKProgressHUD
class FavouriteVC: UIViewController {
    var user = UserModel.init()
    var favVideoList = [VideoObject]()
    @IBOutlet weak var favouriteTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        user = VideonManager.shared().getMyData()
        getAllFavVideoFroUser(userID: Int(user.id) ?? 0)
    }
    
    
    // Add video count
    func getAllFavVideoFroUser(userID:Int)
    {
        DispatchQueue.global().async {
            VideonManager.shared().getAllFavouriteByUser(userIdValue: userID){ (dataList, message) in
                
                DispatchQueue.main.async {
                    
                    if dataList != nil {
                        self.favVideoList = dataList
                        self.favouriteTableView.reloadData()
                        
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
        }
    }
    
    // Navigate to a new view controller
    func goToNextViewControllerWith(videoObject:VideoObject)
    {
        print(videoObject)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        vc.videoObject = videoObject
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension FavouriteVC: UITableViewDelegate, UITableViewDataSource {
    
    // UITable View Delegates
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favVideoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouriteTableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as! VideoListCell
        
        let video = favVideoList[indexPath.row]
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.thumbUrl + video.imageName
        cell.cellImageView.showImage(path: url)
        cell.cellTitleLabel.text = video.title
        cell.category.text = video.category
        cell.resolution.text = self.convertSecondsToHoursMinutesSeconds(seconds: Int(video.duration) ?? 0)
        cell.viewCount.text = video.viewCount
        cell.duration.text = video.created
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = favVideoList[indexPath.row]
        goToNextViewControllerWith(videoObject: video)
    }
    
    func convertSecondsToHoursMinutesSeconds (seconds:Int) -> String {
        let (h, m, s) = VideonManager.shared().secondsToHoursMinutesSeconds (seconds: seconds)
        return ("\(h):\(m):\(s)")
    }
    
}
