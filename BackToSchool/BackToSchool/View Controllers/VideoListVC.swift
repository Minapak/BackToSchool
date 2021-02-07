//
//  VideoListVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//

import UIKit
import WLEmptyState

class VideoListVC: UIViewController, UITextFieldDelegate, WLEmptyStateDataSource{
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var searchInputField: UITextField!
    @IBOutlet weak var videoListTableView: UITableView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var titleBarLabel: UILabel!
    
    var videosByCategoryList = [VideoObject]()
    var paginationValue = 1 // Default
    var categoryValue = 0
    var categoryName = ""
    var searchText = ""
    var titleLabelText = "BackToSchool"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchInputField.delegate = self
        titleBarLabel.text = titleLabelText
        
        videoListTableView.emptyStateDataSource = self
        
        self.searchBarView.layer.cornerRadius = self.searchBarView.frame.height/2
        self.searchBarView.layer.borderWidth = 1
        self.searchBarView.layer.borderColor = UIColor.orange.cgColor
        self.searchBarView.layer.masksToBounds  = true
        
        // Do any additional setup after loading the view.
        self.showSpinner(onView: self.view)
        //필수 시청 영상
        if(categoryName == "featured")
        {
            getFeaturedDataFromServer()
            //가장 많이 본 수업 영상
        } else if(categoryName == "most_popular")
        {
            getPopularDataFromServer()
            
            //최신 수업 영상
        } else if(categoryName == "most_recent")
        {
            getRecentDataFromServer()
        }
        //수업 영상 찾기
        else if(categoryName == "search_video")
        {
            searchInputField.text = searchText
            getSearchDataFromServer()
        }
            
        else
        {
            getVideoListDataFromServer()
        }
        
        
    }
    
    
    // 3
    private func getVideoListDataFromServer() {
        print("From getVideoListDataFromServer method: Page Val\(paginationValue) and Category: \(categoryValue)")
        DispatchQueue.global().async {
            VideonManager.shared().getCategoryWiseVideoListData(pageValue: self.paginationValue, categoryValue: self.categoryValue) { (dataList, message) in
                DispatchQueue.main.async {
                    self.removeSpinner()
                    if dataList != nil {
                        self.videosByCategoryList = dataList
                        self.videoListTableView.reloadData()
                        print(dataList)
                        
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
        }
    }
    
    // 5
    private func getRecentDataFromServer() {
        DispatchQueue.global().async {
            VideonManager.shared().getRecentListData(pageValue: self.paginationValue) { (dataList, message) in
                DispatchQueue.main.async {
                    self.removeSpinner()
                    if dataList != nil {
                        self.videosByCategoryList = dataList
                        self.videoListTableView.reloadData()
                        
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
        }
    }
    
    // 3
    private func getFeaturedDataFromServer() {
        DispatchQueue.global().async {
            VideonManager.shared().getFeaturedListData(pageValue: self.paginationValue) { (dataList, message) in
                DispatchQueue.main.async {
                    self.removeSpinner()
                    if dataList != nil {
                        self.videosByCategoryList = dataList
                        self.videoListTableView.reloadData()
                        
                        
                        
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
        }
    }
    
    // 4
    private func getPopularDataFromServer() {
        DispatchQueue.global().async {
            VideonManager.shared().getPopularListData(pageValue: self.paginationValue) { (dataList, message) in
                DispatchQueue.main.async {
                    self.removeSpinner()
                    if dataList != nil {
                        self.videosByCategoryList = dataList
                        self.videoListTableView.reloadData()
                        
                        
                        
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
        }
    }
    
    // 5
    private func getSearchDataFromServer() {
        DispatchQueue.global().async {
            VideonManager.shared().getSearchVideoListData(pageValue: self.paginationValue, searchText: self.searchText){ (dataList, message) in
                DispatchQueue.main.async {
                    self.removeSpinner()
                    if dataList != nil {
                        self.videosByCategoryList = dataList
                        self.videoListTableView.reloadData()
                        
                        
                        
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //textField code
        textField.resignFirstResponder()  //if desired
        searchText = textField.text ?? ""
        performAction()
        return true
    }
    
    func performAction() {
        self.showSpinner(onView: self.view)
        getSearchDataFromServer()
    }
    
    func goToNextViewControllerWith(videoObject:VideoObject)
    {
        print(videoObject)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        vc.videoObject = videoObject
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func imageForEmptyDataSet() -> UIImage? {
        return UIImage(named: "openbox")
    }
    
    func titleForEmptyDataSet() -> NSAttributedString {
        let title = NSAttributedString(string: "No Data Found", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)])
        return title
    }
    
    func descriptionForEmptyDataSet() -> NSAttributedString {
        let title = NSAttributedString(string: "please try something else", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        return title
    }
    
}

extension VideoListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videosByCategoryList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as! VideoListCell
        
        let video = videosByCategoryList [indexPath.item]
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
        goToNextViewControllerWith(videoObject: videosByCategoryList[indexPath.row])
    }
    
    func convertSecondsToHoursMinutesSeconds (seconds:Int) -> String {
        let (h, m, s) = VideonManager.shared().secondsToHoursMinutesSeconds (seconds: seconds)
        return ("\(h):\(m):\(s)")
    }
    
}
