//
//  ProfileVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//
import UIKit

class ProfileVC: UIViewController {
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    var favVideoList = [VideoObject]()
    var videoPlayList = [VideoObject]()
    
    // this is our array of arrays
    var items = [[VideoObject]]() //let items = [favVideoList, videoPlayList]
    let  sections = ["내가 좋아하는 영상", "나의 영상 리스트"] //let items = [["Apple", "Mango", "Grapes"],["Mac", "Surface", "Windows"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items.append(favVideoList)
        items.append(videoPlayList)
    }
    
    func goToNextViewControllerWith(videoObject:VideoObject)
    {
        print(videoObject)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        vc.videoObject = videoObject
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as! VideoListCell
        
        let video = items[indexPath.section][indexPath.row]
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.thumbUrl + video.imageName
        cell.cellImageView.showImage(path: url)
        cell.cellTitleLabel.text = video.title
        cell.category.text = video.category
        cell.resolution.text = video.imageResolution
        cell.viewCount.text = video.viewCount
        cell.duration.text = video.duration
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = items[indexPath.section][indexPath.row]
        goToNextViewControllerWith(videoObject: video)
    }
    
    
}

