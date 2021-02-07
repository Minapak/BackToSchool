//
//  ViewController.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/28.
//

import UIKit
import DropDown
import Firebase
import SlideMenuControllerSwift

class ViewController: UIViewController, UITextFieldDelegate{
    //MARK: View 선언
    //live 수업 View
    @IBOutlet weak var liveTvView: UIView!
    //이번 주 수업(시험범위) View
    @IBOutlet weak var featuredView: UIView!
    //가장 많이 본 수업 View
    @IBOutlet weak var mostPopularView: UIView!
    //최신 수업 View
    @IBOutlet weak var mostRecentView: UIView!
    
    @IBOutlet weak var liveTvHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var featuredHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var mostPopularHeightConstant: NSLayoutConstraint!

    
    @IBOutlet weak var heightConstantOfMostRecentView: NSLayoutConstraint!
    @IBOutlet weak var videonHomeScrollView: UIScrollView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchIconImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    //MARK: Collection View 선언
    //Collection View?
    //정렬 된 데이터 항목 모음을 관리하고 사용자 지정 가능한 레이아웃을 사용하여 표시하는 개체
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var liveTvCollectionView: UICollectionView!
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    @IBOutlet weak var mostPopularCollectionView: UICollectionView!
    @IBOutlet weak var mostRecentCollectionView: UICollectionView!
    
    @IBOutlet weak var hetghtConstraintOfMostRecentCollectionView: NSLayoutConstraint!
    
    //MARK: 버튼 선언
    @IBOutlet weak var seeAllLiveTVButton: UIButton!
    @IBOutlet weak var seeAllFeaturedButton: UIButton!
    @IBOutlet weak var seeAllMostPopularButton: UIButton!
    @IBOutlet weak var seeAllMostRecentButton: UIButton!
    //MARK: 타이틀 선언
    @IBOutlet weak var liveTvTitleLabel: UILabel!
    @IBOutlet weak var featuredTitleLabel: UILabel!
    @IBOutlet weak var mostPopularTitleLabel: UILabel!
    @IBOutlet weak var mostRecentTitleLabel: UILabel!
    
    @IBOutlet weak var titleBar: UILabel!
    
    //MARK: 타이틀 선언우측 상단 더보기 버튼 클릭시
    @IBAction func moreMenuButtonAction(_ sender: Any) {
        //인터넷 연결되면
        if Connectivity.isConnectedToInternet {
               print("인터넷가능")
               // do some tasks..
            createDropDownMoreMenuOption()
            dropDown.show()
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var moreMenuButton: UIButton!
    
    //MARK: 가장 많이 본 수업 클릭시
    @IBAction func seeAllMostRecentAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoListVC") as! VideoListVC
        vc.categoryName = "most_recent"
        vc.titleLabelText = "MostRecentKey".localizableString(loc: AppUtils.getAppLanguage())
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
    //MARK: 이번 주 수업 클릭시
    @IBAction func seeAllFeaturedAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoListVC") as! VideoListVC
        vc.categoryName = "featured"
        vc.titleLabelText = "FeaturedKey".localizableString(loc: AppUtils.getAppLanguage())
        self.navigationController?.pushViewController(vc, animated: true)

    }
    //MARK: 가장 많이 본 수업 클릭시
    @IBAction func seeAllMostPopularAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoListVC") as! VideoListVC
        vc.categoryName = "most_popular"
        vc.titleLabelText = "MostPopularKey".localizableString(loc: AppUtils.getAppLanguage())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func seeAllLiveTvAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChannelListVC") as! TvListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var categoryItemList = [CategoryObject]()
    var liveTVList = [LiveTvObject]()
    var featuredList = [VideoObject]()
    var mostPopulrarList = [VideoObject]()
    var mostRecentList = [VideoObject]()
    var pagination = 1
    var isNoMoreData = false
    let dropDown = DropDown()
    
    
    let itemWidth = (AppUtils.SCREEN_WIDTH / 4) - 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        titleBar.text="Back To School"
//        self.view.addSubview(titleBar)
        
        if Connectivity.isConnectedToInternet {
               print("인터넷 가능")
               // do some tasks..
            self.showSpinner(onView: self.view)
            self.searchTextField.delegate = self
            self.videonHomeScrollView.delegate = self
            
            cornerRadiousCorrection()
            getCategoryDataFromServer()
            getLiveTvDataFromServer()
            getFeaturedDataFromServer()
            getPopularDataFromServer()
            getRecentDataFromServer()
            createDropDownMoreMenuOption()
            checkVideoFromServer()
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        

        
    }
    
    // 1
    private func checkVideoFromServer() {
        //showLoadingView()
        DispatchQueue.global().async {
            VideonManager.shared().checkVideo(videoIdValue: 1, userIDValue: 1) { (response, message) in
                DispatchQueue.main.async {
                    //self.hideLoadingView()
                    if response != nil {
                        print("checkVideoFromServer: Received Responce: \(response)")
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createDropDownMoreMenuOption()
        // By default app language is chinese
        //AppUtils.setAppLanguage(languageCode: "zh-Hans")
        AppUtils.setAppLanguage(languageCode: "en")
        self.changeLanguage()
    }
    
    func changeLanguage()
    {
        let languageCode = AppUtils.getAppLanguage()
        print("Selected App Language Code: \(languageCode)")
        self.seeAllLiveTVButton.setTitle("SeeAllKey".localizableString(loc: languageCode), for: .normal)
        self.seeAllFeaturedButton.setTitle("SeeAllKey".localizableString(loc: languageCode), for: .normal)
        self.seeAllMostPopularButton.setTitle("SeeAllKey".localizableString(loc: languageCode), for: .normal)
        self.seeAllMostRecentButton.setTitle("SeeAllKey".localizableString(loc: languageCode), for: .normal)
        
        self.liveTvTitleLabel.text = "LiveTvKey".localizableString(loc: languageCode)
        self.featuredTitleLabel.text = "FeaturedKey".localizableString(loc: languageCode)
        self.mostPopularTitleLabel.text = "MostPopularKey".localizableString(loc: languageCode)
        self.mostRecentTitleLabel.text = "MostRecentKey".localizableString(loc: languageCode)
        
    }
    
    func cornerRadiousCorrection(){
        self.view.layoutIfNeeded()
        self.searchBarView.layer.cornerRadius = self.searchBarView.frame.height/2
        self.searchBarView.layer.borderWidth = 1
        self.searchBarView.layer.borderColor = UIColor.orange.cgColor
        self.searchBarView.layer.masksToBounds  = true
        
        self.seeAllLiveTVButton.layer.cornerRadius = self.seeAllLiveTVButton.frame.height/2
        self.seeAllLiveTVButton.layer.borderWidth = 1
        self.seeAllLiveTVButton.layer.borderColor = UIColor.orange.cgColor
        
        self.seeAllLiveTVButton.layer.masksToBounds = true
        
        self.seeAllFeaturedButton.layer.cornerRadius = self.seeAllFeaturedButton.frame.height/2
        self.seeAllFeaturedButton.layer.borderWidth = 1
        self.seeAllFeaturedButton.layer.borderColor = UIColor.orange.cgColor
        self.seeAllFeaturedButton.layer.masksToBounds = true
        
        self.seeAllMostPopularButton.layer.cornerRadius = self.seeAllMostPopularButton.frame.height/2
        self.seeAllMostPopularButton.layer.borderWidth = 1
        self.seeAllMostPopularButton.layer.borderColor = UIColor.orange.cgColor
        self.seeAllMostPopularButton.layer.masksToBounds = true
        
        self.seeAllMostRecentButton.layer.cornerRadius = self.seeAllMostRecentButton.frame.height/2
        self.seeAllMostRecentButton.layer.borderWidth = 1
        self.seeAllMostRecentButton.layer.borderColor = UIColor.orange.cgColor
        self.seeAllMostRecentButton.layer.masksToBounds = true
    
    }
    

    // MARK: 로그인 상태
    func isUserLoggedIn() -> Bool {
        var user = UserModel.init()
        user = VideonManager.shared().getMyData()
        
        return user.id != ""
    }
    
    
    func createDropDownMoreMenuOption(){
        
        // MARK: 드롭 다운 시 보이는 메뉴들
        dropDown.anchorView = moreMenuButton // UIView or UIBarButtonItem
        let menuImageList = ["ic_user_grey", "ic_settings", "ic_history_grey", "ic_paper_grey", "ic_logout_grey"]
        let appLanguageCode = AppUtils.getAppLanguage()
        
        
        if isUserLoggedIn() {
            // Show logout page
            dropDown.dataSource = ["ProfileKey".localizableString(loc: appLanguageCode),
                                   "SettingsKey".localizableString(loc: appLanguageCode),
                                   "PlayListKey".localizableString(loc: appLanguageCode),
                                   "ClassPaperKey".localizableString(loc: appLanguageCode),
                                   "SignOutKey".localizableString(loc: appLanguageCode)]
        } else {
            // Show login page
            dropDown.dataSource = ["ProfileKey".localizableString(loc: appLanguageCode),
                                   "SettingsKey".localizableString(loc: appLanguageCode),
                                   "PlayListKey".localizableString(loc: appLanguageCode),
                                   "ClassPaperKey".localizableString(loc: appLanguageCode),
                                   "SignInKey".localizableString(loc: appLanguageCode)]
        }
        
        
        dropDown.cellNib = UINib(nibName: "MoreMenuCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MoreMenuCell else { return }
            cell.menuCellImageView.image = UIImage(named: menuImageList[index])
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            let appLanguageCode = AppUtils.getAppLanguage()
            
            print("Selected item: \(item) at index: \(index)")
            if(item == "ProfileKey".localizableString(loc: appLanguageCode)){
                if self.isUserLoggedIn() {
                
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    // Show login page
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PleaseLoginVC") as! PleaseLoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                

                
            } else if(item == "SettingsKey".localizableString(loc: appLanguageCode)){
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC1") as! SettingsVC1
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else if(item == "PlayListKey".localizableString(loc: appLanguageCode)){
                
                
                if self.isUserLoggedIn() {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC2") as! ProfileVC2
                        self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    // Show login page
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PleaseLoginVC") as! PleaseLoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                
            } else if(item == "ClassPaperKey".localizableString(loc: appLanguageCode)){
                
                
                if self.isUserLoggedIn() {
                        //UserDefaults.standard.set("0", forKey: UD_userId)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    let sidemenuVC = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
                    let appNavigation: UINavigationController = UINavigationController(rootViewController: vc)
                    appNavigation.setNavigationBarHidden(true, animated: true)
                    let slideMenuController = SlideMenuController(mainViewController: appNavigation, leftMenuViewController: sidemenuVC)
                    slideMenuController.changeLeftViewWidth(UIScreen.main.bounds.width * 0.8)
                    slideMenuController.removeLeftGestures()
                    UIApplication.shared.windows[0].rootViewController = slideMenuController
                    
                } else {
                    // Class Paper 로그인 페이지
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                
            }
            
            
            
            else if(item == "SignOutKey".localizableString(loc: appLanguageCode)){
                
                // create the alert
                let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃을 하시겠습니까？", preferredStyle: UIAlertController.Style.alert)
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "네", style: UIAlertAction.Style.default, handler: { action in
                    // Logout
                    // Manual sign out
                    VideonManager.shared().removeMyData()
                    
                    // Call for sign out
                    do {
                        try Auth.auth().signOut()
                        //수업자료 로그아웃
                        UserDefaults.standard.set("", forKey: UD_userId)
                        self.showToast(message: "로그아웃 완료")
                        //signInSignOutButton.setTitle("SignInKey".localizableString(loc: appLanguageCode), for: .normal)
                        
                       
                        
                    } catch {
                        print("Sign out error")
                        self.showToast(message: "Error 로그아웃")
                    }
                    
                }))
                alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.destructive , handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                
            } else if(item == "SignInKey".localizableString(loc: appLanguageCode)){
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            
        }
        
        // Will set a custom width instead of the anchor view width
        dropDown.width = 200
        
    }
    
    
    
    // 1
    private func getCategoryDataFromServer() {
        //showLoadingView()
        DispatchQueue.global().async {
            VideonManager.shared().getCategoryListData(pageValue: self.pagination) { (dataList, message) in
                DispatchQueue.main.async {
                    //self.hideLoadingView()
                    if dataList != nil {
                        self.categoryItemList = dataList
                        self.categoryCollectionView.reloadData()
                        //self.showHideNoItemView(isInitView: false)
                        
                        
                    
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
        }
    }
    
    
    // 2
    private func getLiveTvDataFromServer() {
        //showLoadingView()
        DispatchQueue.global().async {
            VideonManager.shared().getLiveTvListData(pageValue: self.pagination) { (dataList, message) in
                DispatchQueue.main.async {
                    //self.hideLoadingView()
                    if dataList != nil {

                        if (dataList.count == 0)
                        {
                            self.liveTvView.isHidden = true
                            self.liveTvHeightConstant.constant = CGFloat(0)
                        } else {
                            self.liveTVList = dataList
                            self.liveTvCollectionView.reloadData()
                            //self.showHideNoItemView(isInitView: false)
                        }
                        
                        
                        
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
        }
    }
    
    // 3
    private func getFeaturedDataFromServer() {
        //showLoadingView()
        DispatchQueue.global().async {
            VideonManager.shared().getFeaturedListData(pageValue: self.pagination) { (dataList, message) in
                DispatchQueue.main.async {
                    //self.hideLoadingView()
                    print(" >> >> >> Featured Data List Count: \(dataList.count)")
                    if dataList != nil {
                        if (dataList.count == 0)
                        {
                            self.featuredView.isHidden = true
                            self.featuredHeightConstant.constant = CGFloat(0)
                        } else {
                            self.featuredList = dataList
                            self.featuredCollectionView.reloadData()
                            //self.showHideNoItemView(isInitView: false)
                        }
    
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
        }
    }
    
    // 4
    private func getPopularDataFromServer() {
        //showLoadingView()
        DispatchQueue.global().async {
            VideonManager.shared().getPopularListData(pageValue: self.pagination) { (dataList, message) in
                DispatchQueue.main.async {
                    //self.hideLoadingView()
                    if dataList != nil {

                        if (dataList.count == 0)
                        {
                            self.mostPopularView.isHidden = true
                            self.mostPopularHeightConstant.constant = CGFloat(0)
                        } else {
                            self.mostPopulrarList = dataList
                            self.mostPopularCollectionView.reloadData()
                            //self.showHideNoItemView(isInitView: false)
                        }
                        
                        
                    } else {
                        self.showToast(message: "Opps! Data not found")
                    }
                }
            }
        }
    }
    
    // 5
    private func getRecentDataFromServer() {
        showLoadingViewOnTop(message: "잠시만 기다려주세요...")
        DispatchQueue.global().async {
            VideonManager.shared().getRecentListData(pageValue: self.pagination) { (dataList, message) in
                DispatchQueue.main.async {
                    self.removeSpinner()
                    if dataList != nil {
                        
                        if (dataList.count == 0)
                        {
                            self.mostRecentView.isHidden = true
                            self.heightConstantOfMostRecentView.constant = CGFloat(0)
                        } else {
                            self.mostRecentList = dataList
                            
                            let cell_width = (self.view.frame.width-45)/2
                            let cell_height = (cell_width * 1.57)
                            var cons = 0
                            var arrayCount = self.mostRecentList.count
                            
                            if arrayCount % 2 == 0 {
                                cons = Int((CGFloat)(arrayCount / 2) * (cell_height + 15))
                            } else {
                                arrayCount = arrayCount + 1
                                cons = Int((CGFloat)(arrayCount / 2) * (cell_height + 15))
                            }
                            print("Height Constant: \(cons)")
                            
                            // let cons = (CGFloat)(arrayCount / 2) * (cell_height + 40)
                            self.heightConstantOfMostRecentView.constant = CGFloat(cons + 5)
                            self.view.layoutIfNeeded()
                            self.mostRecentCollectionView.reloadData()
                            //self.showHideNoItemView(isInitView: false)
                        }
                        
                        
                        
                        
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
        performAction()
        return true
    }
    
    func performAction() {
        //action events
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoListVC") as! VideoListVC
        vc.categoryName = "search_video"
        vc.searchText = self.searchTextField.text ?? ""
        vc.titleLabelText = "수업 영상 찾기"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categoryItemList.count
        } else if collectionView == liveTvCollectionView {
            return liveTVList.count
        } else if collectionView == featuredCollectionView {
            return featuredList.count
        } else if collectionView == mostPopularCollectionView {
            return mostPopulrarList.count
        } else if collectionView == mostRecentCollectionView {
            return mostRecentList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCategoryCell", for: indexPath) as! VideonCategoryCell
            
            let category = categoryItemList [indexPath.item]
            let credentials = CredentialGenerator.getBaseCredentials()
            let url = credentials.thumbUrl + category.imageName
            cell.imageView.showCategoryImage(path: url)
            cell.titleLabel.text = category.title
            
            
            return cell
        }
        else if collectionView == liveTvCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvCell", for: indexPath) as! LiveTVCell
            
            let liveTv = liveTVList [indexPath.item]
            let credentials = CredentialGenerator.getBaseCredentials()
            let url = credentials.thumbUrl + liveTv.imageName
            // showCategoryImage uses square shapped placeholder image
            cell.imageView.showCategoryImage(path: url)
            cell.titleLabel.text = liveTv.title
            
            
            return cell
        }
        else if collectionView == featuredCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredCell", for: indexPath) as! FeaturedCell
            
            let featured = featuredList [indexPath.item]
            let credentials = CredentialGenerator.getBaseCredentials()
            let url = credentials.thumbUrl + featured.imageName
            cell.imageView.showImage(path: url)
            cell.titleLabel.text = featured.title
            cell.subTitleLabel.text = featured.category
            
            return cell
        }
        else if collectionView == mostPopularCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mostPopularCell", for: indexPath) as! MostPopularCell
            
            
            let popular = mostPopulrarList [indexPath.item]
            let credentials = CredentialGenerator.getBaseCredentials()
            let url = credentials.thumbUrl + popular.imageName
            cell.imageView.showImage(path: url)
            cell.titleLabel.text = popular.title
            cell.subTitleLabel.text = popular.category
            
            
            return cell
        }
        else if collectionView == mostRecentCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mostRecentCell", for: indexPath) as! MostRecentCell
            
            let recent = mostRecentList [indexPath.item]
            print("RECENT VAL: \(recent)");
            let credentials = CredentialGenerator.getBaseCredentials()
            let url = credentials.thumbUrl + recent.imageName
            cell.imageView.showImage(path: url)
            cell.titleLabel.text = recent.title
            cell.subTitleLabel.text = recent.category
            
            
            return cell
        }
        
        return UICollectionViewCell.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == categoryCollectionView {
            return CGSize(width: 100, height: 120 )
            
            
        }
        else if collectionView == liveTvCollectionView {
            return CGSize(width: 100, height: 120 )
            
        }
        else if collectionView == featuredCollectionView {
            return CGSize(width: 100, height: 175 )
        }
        else if collectionView == mostPopularCollectionView {
            return CGSize(width: 100, height: 175 )
        }
        else if collectionView == mostRecentCollectionView {
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            
            let cell_width = (self.view.frame.width-45)/2
            let cell_height = (cell_width * 1.57)
            
            return CGSize(width: cell_width, height: cell_height)
        }
        else
        {
            return CGSize(width: 0, height: 0 )
        }
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        if Connectivity.isConnectedToInternet {
               print("인터넷가능")
               // do some tasks..
            if collectionView == categoryCollectionView {
                //goToNextViewController()
                goToVideoListController(categoryObject: categoryItemList[indexPath.row])
            }
            else if collectionView == liveTvCollectionView {
                goToTvPlayerViewController(liveTvObject: liveTVList[indexPath.row])
            }
            else if collectionView == featuredCollectionView {
                goToNextViewControllerWith(videoObject: featuredList[indexPath.row])
            }
            else if collectionView == mostPopularCollectionView {
                goToNextViewControllerWith(videoObject: mostPopulrarList[indexPath.row])
            }
            else if collectionView == mostRecentCollectionView {
                goToNextViewControllerWith(videoObject: mostRecentList[indexPath.row])
            }
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func goToTvPlayerViewController(liveTvObject: LiveTvObject)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TvPlayerVC") as! TvPlayerVC
        vc.liveTvObject = liveTvObject
        self.navigationController?.pushViewController(vc, animated: true)
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

