//
//  TvPlayerVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//

import UIKit
import BMPlayer
import TRVideoView
import Cosmos
import GoogleMobileAds


class TvPlayerVC: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {
    var interstitial: GADInterstitial?
    var pagination = 1
    var liveTVList = [LiveTvObject]()
    var liveTvObject = LiveTvObject(id: "",
                                    adminId: "",
                                    status: "",
                                    title: "",
                                    imageName: "",
                                    link: "")
    
    
    
    @IBOutlet weak var player: BMCustomPlayer!
    @IBOutlet weak var youtubePlayerBGView: UIView!
    @IBAction func titleBarBackButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBOutlet weak var liveTvCollectionView: UICollectionView!
    
    @IBOutlet weak var liveTvTitleLabel: UILabel!
    var liveTvTitleText = "Demo"
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
            // do some tasks..
            self.showSpinner(onView: self.view)
            
            getLiveTvDataFromServer()
            
            
            print(liveTvObject)
            youtubePlayerBGView.isHidden = false
            
            if (liveTvObject.link != "") {
                playYoutubeVimeoURL(remoteURL: liveTvObject.link)
            } else if (liveTvObject.link == ""){
                playYoutubeVimeoURL(remoteURL: "https://www.youtube.com/watch?v=ncoVTba_JWA")
            }
            else{
                showAlertDialog(title: "Error!", message: "No valid video url found")
            }
            
            
            if(liveTvObject.title != "")
            {
                liveTvTitleLabel.text = liveTvObject.title
            } else {
                liveTvTitleLabel.text = self.liveTvTitleText
            }
            
            // AdMob
            // Display the intertitial ad
            interstitial = createAndLoadInterstitial()
            
            // Request a Google Ad
            self.view.addSubview(adBannerView)
            
            // iPhone
            adBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: view.frame.size.width, height: 50))
            adBannerView.frame = CGRect(x: 0, y: (view.frame.size.height) - 50, width: view.frame.size.width, height: 50)
            adBannerView.load(GADRequest())
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
    func playVideoFromRemoteURL(remoteFileURL: String){
        youtubePlayerBGView.isHidden = true
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true {
                return
            }
            let _ = self.dismiss(animated: true, completion: nil)
        }
        // "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4"
        let asset = BMPlayerResource(url: URL(string:remoteFileURL )!,
                                     name: "",
                                     cover: nil,
                                     subtitle: nil)
        player.setVideo(resource: asset)
    }
    
    func playYoutubeVimeoURL(remoteURL: String){
        youtubePlayerBGView.isHidden = false
        // Initialize
        // https://youtu.be/KgiwN7ddb2U
        let video = TRVideoView(text: remoteURL)
        
        // Or to play inline, initialize as
        //let video = TRVideoView(text: "This is some sample text with a YouTube link https://www.youtube.com/watch?v=QPAloq5MCUA", allowInlinePlayback: true)
        
        // Set the frame as always, or use AutoLayout
        print("Player Frame X" + youtubePlayerBGView.description)
        
        video.frame = CGRect(x: 0, y: 0, width: youtubePlayerBGView.frame.width, height: youtubePlayerBGView.frame.height)
        
        // Returns true or false (checks for YouTube and Vimeo urls)
        video.containsURLs()
        
        // Returns String with out URLs (i.e. "This is some sample text with a YouTube link")
        let text = video.textWithoutURLs()
        
        // Finally add it to your view
        self.youtubePlayerBGView.addSubview(video)
    }
    
    private func getLiveTvDataFromServer() {
        
        DispatchQueue.global().async {
            VideonManager.shared().getLiveTvListData(pageValue: self.pagination) { (dataList, message) in
                DispatchQueue.main.async {
                    self.removeSpinner()
                    if dataList != nil {
                        self.liveTVList = dataList
                        self.liveTvCollectionView.reloadData()
                        
                        
                        
                        
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
        }
    }
    
    // AdMob Delegates and Helpers
    // MARK: - GADBannerViewDelegate methods
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
        
    }
    
    // MARK: - Help methods
    
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/1033173712")
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        request.testDevices = [ (kGADSimulatorID as! String) ]
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    
    // MARK: - GADInterstitialDelegate methods
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("전면광고 loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
    
}

extension TvPlayerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        
        return CGSize(width: 100, height: 120 )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var link = liveTVList[indexPath.row].link
        if(link != ""){
            playYoutubeVimeoURL(remoteURL: liveTVList[indexPath.row].link)
        } else {
            playYoutubeVimeoURL(remoteURL: "https://youtu.be/KgiwN7ddb2U")
        }
        
        liveTvTitleLabel.text = liveTVList[indexPath.row].title
        
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
