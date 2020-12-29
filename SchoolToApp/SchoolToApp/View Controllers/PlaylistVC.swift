//
//  PlaylistVC.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//

import UIKit
import ZKProgressHUD

class PlaylistVC: UIViewController {
    
    var user = UserModel.init()
    var videoPlayList = [VideoObject]()
    @IBOutlet weak var playlistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        user = VideonManager.shared().getMyData()
        getAllPlayListVideoFroUser(userID: Int(user.id) ?? 0)
    }
    
    
    /// PlayList for user
    /// - Parameter userID: User id number
    func getAllPlayListVideoFroUser(userID:Int){
        
        DispatchQueue.global().async {
            VideonManager.shared().getAllPlaylistByUser(userIdValue: userID, pageValue: 1) { (dataList, message) in
                
                DispatchQueue.main.async {
                    if dataList != nil {
                        self.videoPlayList = dataList
                        self.playlistTableView.reloadData()
                        
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
        }
    }
    
    func goToNextViewControllerWith(videoObject:VideoObject)
    {
        print(videoObject)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        vc.videoObject = videoObject
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PlaylistVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoPlayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playlistTableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as! VideoListCell
        
        let video = videoPlayList[indexPath.row]
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
        let video = videoPlayList[indexPath.row]
        goToNextViewControllerWith(videoObject: video)
    }
    
    func convertSecondsToHoursMinutesSeconds (seconds:Int) -> String {
        let (h, m, s) = VideonManager.shared().secondsToHoursMinutesSeconds (seconds: seconds)
        return ("\(h):\(m):\(s)")
    }
}
