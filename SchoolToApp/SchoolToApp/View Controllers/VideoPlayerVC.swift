//
//  VideoPlayerVC.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//


import UIKit
import BMPlayer
import TRVideoView
import Cosmos
import Photos
import Alamofire
import Firebase
import VersaPlayer


class VideoPlayerVC: UIViewController {
    var video = TRVideoView()
    var user = UserModel.init()
    var pagination = 1
    var videoRating = 0
    var suggestedVideoList = [VideoObject]()
    
    var videoObject = VideoObject(id: "",
                                  category: "",
                                  adminId: "",
                                  status: "",
                                  title: "",
                                  description: "",
                                  imageName: "",
                                  type: "",
                                  uploadedVideo: "",
                                  youtube: "",
                                  vimeo: "",
                                  featured: "",
                                  viewCount: "",
                                  imageResolution: "",
                                  duration: "")
    
    
    
    @IBOutlet weak var titleBarView: UIView!
    
    @IBOutlet weak var suggestedVideosLabel: UILabel!
    @IBOutlet weak var player: BMCustomPlayer!
    @IBOutlet weak var youtubePlayerBGView: UIView!
    @IBOutlet weak var versaPlayerView: VersaPlayerView!
    @IBOutlet weak var controls: VersaPlayerControls!
    @IBAction func titleBarBackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var rateThisImageView: UIImageView!
    @IBOutlet weak var rateThisButton: UIButton!
    
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoRatinglabel: UILabel!
    @IBOutlet weak var videoCategoryLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var videoDescriptionLabel: UILabel!
    @IBOutlet weak var rateThisUIView: UIView!
    @IBOutlet weak var playListButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBAction func rateUsButtonAction(_ sender: Any) {
        
        if self.isUserLoggedIn() {
            
            //=========================
            if(self.user.id == "" || self.videoObject.id == ""){
                // Call for sign out
                // Manual sign out
                VideonManager.shared().removeMyData()
                
                do {
                    try Auth.auth().signOut()
                    // Sign out successful
                    self.showToast(message: "Sign out successfully")
                } catch {
                    print("Sign out error")
                    self.showToast(message: "Sign out error")
                }
                showAlertDialog(title: "Warning!", message: "User information missing, please re-login to access this feature.")
                
                
            }
            else {
                
                if rateThisButton.isSelected {
                    // You have already rated this video
                    showToast(message: "You have already rated this video")
                } else {
                    showPickerController()
                }
                
            }
            
        } else {
            // Show login page
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PleaseLoginVC") as! PleaseLoginVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    @IBAction func addToPlayListButtonAction(_ sender: Any) {
        
        if self.isUserLoggedIn() {
            if(self.user.id == "" || self.videoObject.id == ""){
                // Call for sign out
                // Manual sign out
                VideonManager.shared().removeMyData()
                
                do {
                    try Auth.auth().signOut()
                    self.showToast(message: "Sign out successful")
                } catch {
                    print("Sign out error")
                    self.showToast(message: "Sign out error")
                }
                
                showAlertDialog(title: "Warning!", message: "User information missing, please re-login to access this feature.")
                
                
            }
            else {
                if playListButton.isSelected {
                    removeFromToPlaylist(videoId: Int(videoObject.id)!, userId: Int(user.id)!)
                } else {
                    addToPlaylist(videoId: Int(videoObject.id)!, userId: Int(user.id)!)
                }
            }
            
        } else {
            // Show login page
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PleaseLoginVC") as! PleaseLoginVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
        
        
        
    }
    @IBAction func externalShareButtonAction(_ sender: Any) {
        
        if self.isUserLoggedIn() {
            let text = "Videon"
            let image = UIImage(named: "ic_logo_fav")
            let myWebsite = NSURL(string:"https://codecanyon.net/user/w3engineers/portfolio")
            let shareAll = [text , image! , myWebsite!] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            
        } else {
            // Show login page
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PleaseLoginVC") as! PleaseLoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    @IBAction func favouriteButtonAction(_ sender: Any) {
        
        
        if self.isUserLoggedIn() {
            if(self.user.id == "" || self.videoObject.id == ""){
                // Manual sign out
                VideonManager.shared().removeMyData()
                
                // Call for sign out
                do {
                    try Auth.auth().signOut()
                    self.showToast(message: "Sign out successful")
                } catch {
                    print("Sign out error")
                    self.showToast(message: "Sign out error")
                }
                
                showAlertDialog(title: "Warning!", message: "User information missing, please re-login to access this feature.")
                
            } else {
                if favouriteButton.isSelected {
                    //print("I am not selected.")
                    removeFromFavourite(userId: Int(user.id)!, videoId: Int(videoObject.id)!)
                    
                } else {
                    //print("I am selected.")
                    addToFavourite(userId:Int(user.id)! , videoId: Int(videoObject.id)! )
                }
            }
            
            
        } else {
            // Show login page
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PleaseLoginVC") as! PleaseLoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
        
    }
    @IBAction func downloadVideoButtonAction(_ sender: Any) {
        
    }
    
    @IBOutlet weak var suggestedVideoView: UIView!
    @IBOutlet weak var suggestedCollectionView: UICollectionView!
    
    
    func isUserLoggedIn() -> Bool {
        var user = UserModel.init()
        user = VideonManager.shared().getMyData()
        
        return user.id != ""
    }
    
    
    private func getSuggestedVideoDataFromServer(ID: Int) {
        DispatchQueue.global().async {
            VideonManager.shared().getSuggestedVideoListData(pageValue: self.pagination, ID: 23) { (dataList, message) in
                DispatchQueue.main.async {
                    print(dataList.description)
                    if dataList != nil {
                        self.suggestedVideoList = dataList
                        self.suggestedCollectionView.reloadData()
                        
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
            VideonManager.shared().getRecentListData(pageValue: self.pagination) { (dataList, message) in
                DispatchQueue.main.async {
                    self.removeSpinner()
                    if dataList != nil {
                        self.suggestedVideoList = dataList
                        self.suggestedCollectionView.reloadData()
                        
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
        }
    }
    func showPickerController() {
        let alertController = UIAlertController(title: "Rate Us", message: nil, preferredStyle: .alert)
        let customView = UIView()
        alertController.view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45).isActive = true
        customView.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        customView.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        let ratingView = CosmosView()
        ratingView.rating = 0.0
        ratingView.settings.starSize = 30
        ratingView.settings.emptyBorderColor = UIColor.black
        ratingView.settings.updateOnTouch = true
        ratingView.didTouchCosmos = didTouchCosmos
        
        let yCoord = CGFloat(2.0)
        ratingView.frame = CGRect(x: 0, y: 0, width: 170.0, height: 40.0)
        ratingView.center.x = alertController.view.center.x - 60
        ratingView.frame.origin.y = yCoord
        customView.addSubview(ratingView)
        
        let textView = UITextView(frame: CGRect(x: 10, y: 70, width: ratingView.frame.width - 10, height: 100.0))
        textView.textContainerInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 8, right: 5)
        customView.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 90).isActive = true
        textView.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        textView.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        let selectAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            print("Submit Selected")
            if(textView.text != "") {
                if(self.videoRating <= 0){
                    self.showAlertDialog(title: "Warning!", message: "Please give some rating before submitting.")
                } else {
                    self.submitReview(videoId: Int(self.videoObject.id)!, userId: Int(self.user.id)!, rating: self.videoRating, review: textView.text ?? "")
                }
                
                
            } else {
                self.showAlertDialog(title: "Warning!", message: "Please write a short comment before submitting.")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive){ (action) in
            print("Cancel Selected")
        }
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: {
            textView.becomeFirstResponder()
            UIView.animate(withDuration: 0.2, animations: {
                alertController.view.frame.origin.y = 150
            })
        })
    }
    
    func formatValue(_ value: Double) -> Int {
        return Int(value)
    }
    
    private func didTouchCosmos(_ rating: Double) {
        videoRating = formatValue(rating)
        print(videoRating)
        
    }
    
    // Add video count
    func addVideoViewCount(videoID:Int)
    {
        DispatchQueue.global().async {
            VideonManager.shared().addVideoViewCount(videoIdValue: videoID){ (response, message) in
                
                DispatchQueue.main.async {
                    //self.removeSpinner()
                    if response != nil {
                        if (response.status == 200)
                        {
                            
                            // Parsing the data:
                            if let videoCheckMap = response.data as? [String : Any] {
                                
                                let viewCount = videoCheckMap["view_count"] as! Int
                                let viewCountText = String(describing: viewCount)
                                let videoDescription = videoCheckMap["description"] as! String ?? ""
                                let videoTitle = videoCheckMap["title"] as! String ?? ""
                                print("View Count: \(videoDescription)")
                                self.viewCountLabel.text = viewCountText
                                self.videoTitleLabel.text = videoTitle
                                
                                
                                if (videoDescription != "") {
                                    self.videoDescriptionLabel.isHidden = false
                                    self.videoDescriptionLabel.text = videoDescription
                                } else {
                                    self.videoDescriptionLabel.isHidden = true
                                }
                            }
                            
                        }
                        
                    } else {
                        //self.showToast(message: response.message)
                        
                    }
                    
                }
            }
        }
    }
    
    // Add to favourite
    func addToFavourite(userId: Int, videoId: Int)
    {
        DispatchQueue.global().async {
            VideonManager.shared().addToFavouriteList(userIdValue: userId, videoIdValue: videoId){ (response, message) in
                
                DispatchQueue.main.async {
                    //self.removeSpinner()
                    if response != nil {
                        if (response.status == 200)
                        {
                            self.showToast(message: "Added to favourite")
                            self.favouriteButton.isSelected = true
                            self.favouriteButton.layer.borderColor = UIColor.orange.cgColor
                        }
                        else {
                            self.showToast(message: response.message)
                        }
                        
                    } else {
                        self.showToast(message: "Opps! something went wrong")
                        self.favouriteButton.isSelected = false
                        self.favouriteButton.layer.borderColor = UIColor.lightGray.cgColor
                    }
                    
                }
            }
        }
    }
    
    // Remove from favourite
    func removeFromFavourite(userId: Int, videoId: Int)
    {
        DispatchQueue.global().async {
            VideonManager.shared().removeFromFavouriteList(userIdValue: userId, videoIdValue: videoId){ (response, message) in
                
                DispatchQueue.main.async {
                    //self.removeSpinner()
                    if response != nil {
                        if (response.status == 200)
                        {
                            self.showToast(message: "Removed from favourite")
                            self.favouriteButton.isSelected = false
                            self.favouriteButton.layer.borderColor = UIColor.lightGray.cgColor
                        }
                        else {
                            self.showToast(message: response.message)
                        }
                        
                    } else {
                        self.showToast(message: "Opps! something went wrong")
                        self.favouriteButton.isSelected = true
                        self.favouriteButton.layer.borderColor = UIColor.orange.cgColor
                    }
                    
                }
            }
        }
    }
    
    
    
    
    
    
    // Playlist
    // REMOVE from playlist
    func removeFromToPlaylist(videoId: Int, userId: Int){
        DispatchQueue.global().async {
            VideonManager.shared().removeFromPlaylist(userIdValue: userId, videoIdValue:videoId ){ (response, message) in
                
                DispatchQueue.main.async {
                    //self.removeSpinner()
                    if response != nil {
                        if (response.status == 200)
                        {
                            // Removed from playlist
                            self.showToast(message: "Removed from playlist")
                            self.playListButton.isSelected = false
                            self.playListButton.layer.borderColor = UIColor.lightGray.cgColor
                        }
                        else {
                            self.showToast(message: response.message)
                        }
                        
                    } else {
                        self.showToast(message: "Opps! something went wrong")
                        self.playListButton.isSelected = true
                        self.playListButton.layer.borderColor = UIColor.orange.cgColor
                    }
                    
                }
            }
        }
    }
    
    
    // ADD to playlist
    func addToPlaylist(videoId: Int, userId: Int){
        DispatchQueue.global().async {
            VideonManager.shared().addToPlaylist(userIdValue: userId, videoIdValue: videoId  ) { (response, message) in
                
                DispatchQueue.main.async {
                    //self.removeSpinner()
                    if response != nil {
                        if (response.status == 200)
                        {   // Added to playlist
                            self.showToast(message: "Added to playlist")
                            self.playListButton.isSelected = true
                            self.playListButton.layer.borderColor = UIColor.orange.cgColor
                        }
                        else {
                            self.showToast(message: response.message)
                        }
                        
                    } else {
                        self.showToast(message: "Opps! something went wrong")
                        self.playListButton.isSelected = false
                        self.playListButton.layer.borderColor = UIColor.lightGray.cgColor
                    }
                    
                }
            }
        }
    }
    
    /// Submit For Review
    /// - Parameters:
    ///   - videoId: Int
    ///   - userId: Int
    ///   - rating: Int
    ///   - review: String
    func submitReview (videoId: Int, userId: Int, rating: Int, review:String){
        DispatchQueue.global().async {
            VideonManager.shared().addReview(videoIdValue: Int(self.videoObject.id)!, userIdValue: Int(self.user.id)!, ratingValue: rating, reviewValue: review) { (response, message) in
                DispatchQueue.main.async {
                    //self.removeSpinner()
                    if response != nil {
                        if (response.status == 200)
                        {
                            self.showToast(message: "Review submitted successfully")
                            self.rateThisImageView.image = UIImage.init(named: "ic_rate_orange")
                            self.rateThisUIView.layer.borderColor = UIColor.orange.cgColor
                            self.rateThisButton.isSelected = true
                        }
                        print("checkVideoFromServer: Received Responce: \(response)")
                        
                    } else {
                        self.showToast(message: "Opps! something went wrong")
                        self.rateThisImageView.image = UIImage.init(named: "ic_rate_gray")
                        self.rateThisUIView.layer.borderColor = UIColor.lightGray.cgColor
                        self.rateThisButton.isSelected = false
                    }
                    
                }
            }
        }
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            //self.titleBarView.isHidden = true
            //self.view.backgroundColor = UIColor.black
            //video.frame = CGRect(x: 0, y: 0, width: self.view.frame.width , height: self.view.frame.height)
            //setNeedsStatusBarAppearanceUpdate()
            
        } else {
            print("Portrait")
            //self.titleBarView.isHidden = false
            //self.view.backgroundColor = UIColor.white
            //video.frame = CGRect(x: 0, y: 0, width: youtubePlayerBGView.frame.width, height: youtubePlayerBGView.frame.height)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Connectivity.isConnectedToInternet {
               print("Yes! internet is available.")
               // do some tasks..
            NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
            
            // Init UI from video object
            videoTitleLabel.text = videoObject.title
            videoRatinglabel.text = videoObject.status
            videoCategoryLabel.text = videoObject.category
            //durationLabel.text = videoObject.imageResolution
            durationLabel.text = self.convertSecondsToHoursMinutesSeconds(seconds: Int(videoObject.duration) ?? 0)
            viewCountLabel.text = videoObject.viewCount
            createdLabel.text = videoObject.created
            
            if (videoObject.description != "") {
                videoDescriptionLabel.isHidden = false
                videoDescriptionLabel.text = videoObject.description
            } else {
                videoDescriptionLabel.isHidden = true
            }
            
            self.showSpinner(onView: self.view)
            getRecentDataFromServer()
            
            prepareUI()
            
            print(videoObject)
            youtubePlayerBGView.isHidden = false
            loadVideoFromUrl(videoObject: videoObject)
            
            user = VideonManager.shared().getMyData()
            getVideoCheckStatus()
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.addVideoViewCount(videoID: Int(self.videoObject.id)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Player FRAME: \(self.player.frame)")
    }
    
    func getVideoCheckStatus(){
        
        DispatchQueue.global().async {
            VideonManager.shared().checkVideo(videoIdValue: Int(self.videoObject.id) ?? 0, userIDValue: Int(self.user.id) ?? 0) { (response, message) in
                DispatchQueue.main.async {
                    //self.removeSpinner()
                    if response != nil {
                        print("getVideoCheckStatus: Received Responce: \(response)")
                        
                        // Parsing the data:
                        if let videoCheckMap = response.data as? [String : Any] {
                            let totalUser = videoCheckMap["total_users"] as? Int
                            let avgRating = videoCheckMap["avg_rating"] as? String
                            let viewCount = videoCheckMap["view_count"] as? Int
                            print(">>> \(totalUser ?? 0)(\(avgRating ?? ""))")
                            let videorating = "\(totalUser ?? 0)(\(avgRating ?? ""))"
                            
                            self.videoRatinglabel.text = videorating
                            if (videoCheckMap["review"] as? Int  == 0){
                                self.rateThisImageView.image = UIImage.init(named: "ic_rate_gray")
                                self.rateThisUIView.layer.borderColor = UIColor.lightGray.cgColor
                                self.rateThisButton.isSelected = false
                            } else {
                                self.rateThisImageView.image = UIImage.init(named: "ic_rate_orange")
                                self.rateThisUIView.layer.borderColor = UIColor.orange.cgColor
                                self.rateThisButton.isSelected = true
                            }
                            
                            if (videoCheckMap["playlist"] as? Int == 0){
                                self.playListButton.isSelected = false
                                self.playListButton.layer.borderColor = UIColor.lightGray.cgColor
                            } else {
                                self.playListButton.isSelected = true
                                self.playListButton.layer.borderColor = UIColor.orange.cgColor
                                
                            }
                            
                            if (videoCheckMap["favourite"] as? Int == 0){
                                self.favouriteButton.isSelected = false
                                self.favouriteButton.layer.borderColor = UIColor.lightGray.cgColor
                            } else {
                                self.favouriteButton.isSelected = true
                                self.favouriteButton.layer.borderColor = UIColor.orange.cgColor
                                
                            }
                            
                            
                            print("Get video check status: \(videoCheckMap)")
                            
                        }
                        
                    } else {
                        self.showToast(message: "Opps! Something went wrong, fetching video info")
                    }
                    
                }
            }
        }
        
    }
    
    
    func loadVideoFromUrl(videoObject:VideoObject) {
        print ("Video Object: \(videoObject)" )
        switch (videoObject.type) {
            
        // Youtube
        case "1":
            playYoutubeVimeoURL(remoteURL: videoObject.youtube)
            break
            
        // Vimeo
        case "2":
            playYoutubeVimeoURL(remoteURL: videoObject.vimeo)
            break
            
        // Uploaded Video
        case "3":
            
            let credentials = CredentialGenerator.getBaseCredentials()
            print("# BASE: \(credentials.baseUrl)")
            print("# FILE: \(credentials.fileUrl)")
            print("# THUMB: \(credentials.thumbUrl)")
            
            let url = credentials.fileUrl + videoObject.uploadedVideo
            playVideoFromRemoteURL(remoteFileURL: url)
            
            break
            
            
        // mp4 link
        case "5":
            
            let url = videoObject.videoLink
            playVideoFromRemoteURL(remoteFileURL: url)
            break
            
            
        default:
            showAlertDialog(title: "Error!", message: "No valid video url found")
            break
        }
        
        
        
    }
    
    func prepareUI(){
        
        self.rateThisUIView.layer.cornerRadius = self.rateThisUIView.frame.height/2
        self.playListButton.layer.cornerRadius = self.playListButton.frame.height/2
        self.shareButton.layer.cornerRadius = self.shareButton.frame.height/2
        self.favouriteButton.layer.cornerRadius = self.favouriteButton.frame.height/2
        self.downloadButton.layer.cornerRadius = self.downloadButton.frame.height/2
        
        self.rateThisUIView.layer.borderWidth = 2
        self.playListButton.layer.borderWidth = 2
        self.shareButton.layer.borderWidth = 2
        self.favouriteButton.layer.borderWidth = 2
        self.downloadButton.layer.borderWidth = 2
        
        self.rateThisUIView.layer.borderColor = UIColor.lightGray.cgColor
        self.playListButton.layer.borderColor = UIColor.lightGray.cgColor
        self.shareButton.layer.borderColor = UIColor.lightGray.cgColor
        self.favouriteButton.layer.borderColor = UIColor.lightGray.cgColor
        self.downloadButton.layer.borderColor = UIColor.lightGray.cgColor
        
        self.rateThisUIView.layer.masksToBounds  = true
        self.playListButton.layer.masksToBounds  = true
        self.shareButton.layer.masksToBounds  = true
        self.favouriteButton.layer.masksToBounds  = true
        self.downloadButton.layer.masksToBounds  = true
    }
    
    func videoUrlValodator(videoUrl: String) -> String {
        var streamUrl = videoUrl
        
        if streamUrl.contains("adilo.bigcommand.com/watch") {
            print("exists")
            if (streamUrl.last! == "/") {
                streamUrl = String (streamUrl.dropLast(1))
            }
            
            let streamUrlTokens = streamUrl.components(separatedBy: "/")
            let videoID = streamUrlTokens.last as! String
            // Sample URL For Leon Lee
            // https://stream.adilo.com/adilo-encoding/tairsunaolcom/3NZpRT4Z/hls/master.m3u8
            
            let streamFileUrl_m3u8 = "https://stream.adilo.com/adilo-encoding/tairsunaolcom/\(videoID)/hls/master.m3u8"
            print (streamUrlTokens)
            print (videoID)
            print (streamFileUrl_m3u8)
            
            return streamFileUrl_m3u8
        } else {
            print (streamUrl)
            return streamUrl
        }
    }
    
    func playVideoFromRemoteURL(remoteFileURL: String){
        
        // TODO: FOR TESTING ONLY
        //var remoteFileURL = "https://stream.adilo.com/adilo-encoding/tairsunaolcom/3NZpRT4Z/hls/master.m3u8"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = true
        self.video.removeFromSuperview()
        self.view.layoutIfNeeded()
        versaPlayerView.layer.backgroundColor = UIColor.black.cgColor
        versaPlayerView.use(controls: controls)
        versaPlayerView.controls?.behaviour.shouldHideControls = true
        
        if let url = URL.init(string: self.videoUrlValodator(videoUrl: remoteFileURL)) {
            print(">>>> Stream URL IS: <<< \(url)")
            let item = VersaPlayerItem(url: url)
            versaPlayerView.set(item: item)
        }
        
        
    }
    
    func playYoutubeVimeoURL(remoteURL: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = false
        
        self.video.isHidden = false
        video = TRVideoView(text: remoteURL)
        video.frame = CGRect(x: 0, y: 0, width: youtubePlayerBGView.frame.width, height: youtubePlayerBGView.frame.height)
        
        // Returns true or false (checks for YouTube and Vimeo urls)
        video.containsURLs()
        
        // Returns String with out URLs (i.e. "This is some sample text with a YouTube link")
        let text = video.textWithoutURLs()
        self.video.removeFromSuperview()
        // Finally add it to your view
        self.youtubePlayerBGView.addSubview(video)
    }
    
    
    
    func convertSecondsToHoursMinutesSeconds (seconds:Int) -> String {
        let (h, m, s) = VideonManager.shared().secondsToHoursMinutesSeconds (seconds: seconds)
        return ("\(h):\(m):\(s)")
    }
}

extension VideoPlayerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestedVideoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredCell", for: indexPath) as! FeaturedCell
        let suggestedVideo = suggestedVideoList [indexPath.item]
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.thumbUrl + suggestedVideo.imageName
        cell.imageView.showImage(path: url)
        cell.titleLabel.text = suggestedVideo.title
        cell.subTitleLabel.text = suggestedVideo.category
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 175 )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadVideoFromUrl(videoObject: suggestedVideoList[indexPath.row])
        addVideoViewCount(videoID: Int(suggestedVideoList[indexPath.row].id)!)
        
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

