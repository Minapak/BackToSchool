//
//  VideoManager.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//

import Foundation

class VideonManager  {
    
    var userToken: String = ""
    var featuredPage = 0
    //var songAllTracks: [AudioObject] = []
    var isLogin = false
    
    private static var sharedStreamzManager: VideonManager = {
        let videonManager = VideonManager()
        return videonManager
    }()
    
    class func shared() -> VideonManager {
        return sharedStreamzManager
    }
    
    // Debug Only
    func printResponse(methodName: String, responseVal: ResponseModel)
    {
        print("debug: =================^^^=================")
        print("debug: ### \(methodName) >>:>> \(responseVal)")
        print("debug: =================vvv=================")
    }
    
    // Send verification code
    func sendVerificationCode(emailValue: String, complitionHandler: @escaping(_ responseData: ResponseModel, _ errorMsg: String) -> Void){
        let requestInfo = ServerMapper.sendCodeInfo(email: emailValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            self.printResponse(methodName: "sendVerificationCode", responseVal: response ?? ResponseModel.init())
            complitionHandler(response ?? ResponseModel.init(), response?.message ?? "")
        }
    }
    
    
    // Update password
    func updatePassword(emailValue: String, verificationTokenValue: String, passwordValue: String, complitionHandler: @escaping(_ responseData: ResponseModel, _ errorMsg: String) -> Void){
        let requestInfo = ServerMapper.updatePasswordInfo(email: emailValue, verificationToken: verificationTokenValue, password: passwordValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            self.printResponse(methodName: "updatePassword", responseVal: response ?? ResponseModel.init())
            complitionHandler(response ?? ResponseModel.init(), response?.message ?? "")
        }
    }
    
    // Email verification
    func verifyEmail(emailValue: String, verificationTokenValue: String, complitionHandler: @escaping(_ responseData: ResponseModel, _ errorMsg: String) -> Void){
        let requestInfo = ServerMapper.emailVerificationInfo(email: emailValue, verificationToken: verificationTokenValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            self.printResponse(methodName: "verifyEmail", responseVal: response ?? ResponseModel.init())
            complitionHandler(response ?? ResponseModel.init(), response?.message ?? "")
        }
    }
    
    // Check Video Info
    func checkVideo(videoIdValue: Int, userIDValue: Int, complitionHandler: @escaping(_ responseData: ResponseModel, _ errorMsg: String) -> Void){
        let requestInfo = ServerMapper.checkVideoInfo(videoId: videoIdValue, userID: userIDValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            self.printResponse(methodName: "checkVideo", responseVal: response ?? ResponseModel.init())
            complitionHandler(response ?? ResponseModel.init(), response?.message ?? "")
        }
    }
    
    
    // Get Video Settings from server
    func getSettings(reviewValue: String, complitionHandler: @escaping(_ responseData: ResponseModel, _ errorMsg: String) -> Void){
        let requestInfo = ServerMapper.settingInfo()
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            self.printResponse(methodName: "getSettings", responseVal: response ?? ResponseModel.init())
            complitionHandler(response ?? ResponseModel.init(), response?.message ?? "")
            
        }
    }
    
    // Add a review
    func addReview(videoIdValue: Int, userIdValue: Int, ratingValue: Int, reviewValue: String, complitionHandler: @escaping(_ responseData: ResponseModel, _ errorMsg: String) -> Void){
        let requestInfo = ServerMapper.addReviewInfo(videoId: videoIdValue, userId: userIdValue, rating: ratingValue, review: reviewValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            self.printResponse(methodName: "addReview", responseVal: response ?? ResponseModel.init())
            complitionHandler(response ?? ResponseModel.init(), response?.message ?? "")
            
        }
        
    }
    
    // Add video view count
    func addVideoViewCount(videoIdValue: Int, complitionHandler: @escaping(_ responseData: ResponseModel, _ errorMsg: String) -> Void){
        let requestInfo = ServerMapper.addViewCountInfo(videoId: videoIdValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            self.printResponse(methodName: "addVideoViewCount", responseVal: response ?? ResponseModel.init())
            complitionHandler(response ?? ResponseModel.init(), response?.message ?? "")
            
        }
        
        
    }
    
    
    // All playlist by user
    func getAllPlaylistByUser(userIdValue: Int, pageValue: Int, complitionHandler: @escaping(_ dataList: [VideoObject], _ errorMsg: String) -> Void){
        let requestInfo = ServerMapper.getAllPlaylistByUserInfo(userId: userIdValue, page: pageValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            if response?.status == 200 {
                if let mainArray = response?.data as? Array<Any> {
                    complitionHandler(self.convertVideoMapToObjectList(videoMapList: mainArray), "")
                } else {
                    complitionHandler([], response?.message ?? "")
                }
            } else {
                complitionHandler([], response?.message ?? "")
            }
            
        }
    }
    
    
    // All favourite by user
    func getAllFavouriteByUser(userIdValue: Int, complitionHandler: @escaping(_ dataList: [VideoObject], _ errorMsg: String) -> Void){
        let requestInfo = ServerMapper.getAllFavouriteByUserInfo(userId: userIdValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            if response?.status == 200 {
                if let mainArray = response?.data as? Array<Any> {
                    complitionHandler(self.convertVideoMapToObjectList(videoMapList: mainArray), "")
                } else {
                    complitionHandler([], response?.message ?? "")
                }
            } else {
                complitionHandler([], response?.message ?? "")
            }
        }
    }
    

    
    // Add to playlist by user
    func addToPlaylist(userIdValue: Int, videoIdValue: Int, complitionHandler: @escaping(_ responseData: ResponseModel, _ errorMsg: String) -> Void){
        let requestInfo = ServerMapper.addPlayListInfo(videoId: videoIdValue, userId: userIdValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            self.printResponse(methodName: "addToPlaylist", responseVal: response ?? ResponseModel.init())
            complitionHandler(response ?? ResponseModel.init(), response?.message ?? "")
            
        }
    }
    
    // Remove from playlist by user
    func removeFromPlaylist(userIdValue: Int, videoIdValue: Int, complitionHandler: @escaping(_ responseData: ResponseModel, _ errorMsg: String) -> Void){
        let requestInfo = ServerMapper.removePlayListInfo(userId: userIdValue, videoId: videoIdValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            self.printResponse(methodName: "removeFromPlaylist", responseVal: response ?? ResponseModel.init())
            complitionHandler(response ?? ResponseModel.init(), response?.message ?? "")
            
        }
    }
    
    // Add to favourite
    func addToFavouriteList(userIdValue: Int, videoIdValue: Int, complitionHandler: @escaping(_ responseData: ResponseModel, _ errorMsg: String) -> Void){
        let requestInfo = ServerMapper.addFavouriteInfo(userId: userIdValue, videoId: videoIdValue)
        
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            self.printResponse(methodName: "addToFavouriteList", responseVal: response ?? ResponseModel.init())
            complitionHandler(response ?? ResponseModel.init(), response?.message ?? "")
            
        }
    }
    
    // Remove from favourite
    func removeFromFavouriteList(userIdValue: Int, videoIdValue: Int, complitionHandler: @escaping(_ responseData: ResponseModel, _ errorMsg: String) -> Void){
        let requestInfo = ServerMapper.removeFavouriteInfo(userId: userIdValue, videoId: videoIdValue)
        
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            self.printResponse(methodName: "removeFromFavouriteList", responseVal: response ?? ResponseModel.init())
            complitionHandler(response ?? ResponseModel.init(), response?.message ?? "")
            
        }
    }
    
    
    
    
    // LogIn
    func logIn(emailValue: String, passwordValue: String, complitionHandler: @escaping(_ responseData: ResponseModel, _ errorMsg: String) -> Void) {
        let requestInfo = ServerMapper.loginUserInfo(email: emailValue, password: passwordValue)
        
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            self.printResponse(methodName: "logIn", responseVal: response ?? ResponseModel.init())
            complitionHandler(response ?? ResponseModel.init(), response?.message ?? "")
            
        }
    }
    
    
    
    // SignUp
    // Type: 1 = Email, 2 = Google, 3 = Facebook
    func signUp(registrationType: Int, socialIdValue: String, nameValue: String, emailValue: String, passwordValue: String, complitionHandler: @escaping(_ responseData: ResponseModel, _ errorMsg: String) -> Void)
    {
        let requestInfo = ServerMapper.signUpUserInfo(type: registrationType, socialId: socialIdValue, name: nameValue, email: emailValue, password: passwordValue)
        
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param){ (response) in
            self.printResponse(methodName: "signUp", responseVal: response ?? ResponseModel.init())
            complitionHandler(response ?? ResponseModel.init(), response?.message ?? "")
            
        }
    }
    
    // Get Category Wise VideoList Data
    func getCategoryWiseVideoListData(pageValue: Int, categoryValue: Int, complitionHandler: @escaping(_ dataList: [VideoObject], _ errorMsg: String) -> Void) {
        let requestInfo = ServerMapper.getCategoryWiseVideoRequestInfo(page: pageValue, category: categoryValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param) { (response) in
            self.printResponse(methodName: "getCategoryWiseVideoListData", responseVal: response ?? ResponseModel.init())
            if response?.status == 200 {
                if let mainArray = response?.data as? Array<Any> {
                    complitionHandler(self.convertVideoMapToObjectList(videoMapList: mainArray), "")
                } else {
                    complitionHandler([], response?.message ?? "")
                }
            } else {
                complitionHandler([], response?.message ?? "")
            }
        }
    }
    
    // Get Category List Data
    func getCategoryListData(pageValue: Int, complitionHandler: @escaping(_ dataList: [CategoryObject], _ errorMsg: String) -> Void) {
        let requestInfo = ServerMapper.getCategoryRequestInfo(page: pageValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param) { (response) in
            if response?.status == 200 {
                if let mainArray = response?.data as? Array<Any> {
                    complitionHandler(self.convertCategoryMapToObjectList(categoryMapList: mainArray), "")
                } else {
                    complitionHandler([], response?.message ?? "")
                }
            } else {
                complitionHandler([], response?.message ?? "")
            }
        }
    }
    
    // get Live Tv List Data
    func getLiveTvListData(pageValue: Int, complitionHandler: @escaping(_ dataList: [LiveTvObject], _ errorMsg: String) -> Void) {
        let requestInfo = ServerMapper.getLiveTvRequestInfo(page: pageValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param) { (response) in
            if response?.status == 200 {
                if let mainArray = response?.data as? Array<Any> {
                    complitionHandler(self.convertLiveTvMapToObjectList(liveTvMapList: mainArray), "")
                } else {
                    complitionHandler([], response?.message ?? "")
                }
            } else {
                complitionHandler([], response?.message ?? "")
            }
        }
    }
    
    // Get Featured List Data
    func getFeaturedListData(pageValue: Int, complitionHandler: @escaping(_ dataList: [VideoObject], _ errorMsg: String) -> Void) {
        let requestInfo = ServerMapper.getFeaturedRequestInfo(page: pageValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param) { (response) in
            
            print(">> Featured Response: \(response)")
            if response?.status == 200 {
                if let mainArray = response?.data as? Array<Any> {
                    complitionHandler(self.convertFeaturedMapToObjectList(featuredMapList: mainArray), "")
                } else {
                    complitionHandler([], response?.message ?? "")
                }
            } else {
                complitionHandler([], response?.message ?? "")
            }
        }
    }
    
    // Get Popular List Data
    func getPopularListData(pageValue: Int, complitionHandler: @escaping(_ dataList: [VideoObject], _ errorMsg: String) -> Void) {
        let requestInfo = ServerMapper.getPopularRequestInfo(page: pageValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param) { (response) in
            if response?.status == 200 {
                if let mainArray = response?.data as? Array<Any> {
                    complitionHandler(self.convertPopularMapToObjectList(popularMapList: mainArray), "")
                } else {
                    complitionHandler([], response?.message ?? "")
                }
            } else {
                complitionHandler([], response?.message ?? "")
            }
        }
    }
    
    // Get Recent List Data
    func getRecentListData(pageValue: Int, complitionHandler: @escaping(_ dataList: [VideoObject], _ errorMsg: String) -> Void) {
        let requestInfo = ServerMapper.getRecentRequestInfo(page: pageValue)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param) { (response) in
            if response?.status == 200 {
                if let mainArray = response?.data as? Array<Any> {
                    complitionHandler(self.convertRecentMapToObjectList(recentMapList: mainArray), "")
                } else {
                    complitionHandler([], response?.message ?? "")
                }
            } else {
                complitionHandler([], response?.message ?? "")
            }
        }
    }
    
    // Search Video
    func getSearchVideoListData(pageValue: Int, searchText:String, complitionHandler: @escaping(_ dataList: [VideoObject], _ errorMsg: String) -> Void) {
        let requestInfo = ServerMapper.getSearchVideoRequestInfo(searchText: searchText)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param) { (response) in
            if response?.status == 200 {
                if let mainArray = response?.data as? Array<Any> {
                    complitionHandler(self.convertVideoMapToObjectList(videoMapList: mainArray), "")
                } else {
                    complitionHandler([], response?.message ?? "")
                }
            } else {
                complitionHandler([], response?.message ?? "")
            }
        }
    }
    
    // Suggested video
    func getSuggestedVideoListData(pageValue: Int, ID: Int, complitionHandler: @escaping(_ dataList: [VideoObject], _ errorMsg: String) -> Void) {
        let requestInfo = ServerMapper.getSuggestedVideoRequestInfo(page: pageValue, id: ID)
        ServerManager.requestForPostData(url: requestInfo.url, param: requestInfo.param) { (response) in
            self.printResponse(methodName: "getSuggestedVideoListData", responseVal: response ?? ResponseModel.init())
            if response?.status == 200 {
                if let mainArray = response?.data as? Array<Any> {
                    complitionHandler(self.convertVideoMapToObjectList(videoMapList: mainArray), "")
                } else {
                    complitionHandler([], response?.message ?? "")
                }
            } else {
                complitionHandler([], response?.message ?? "")
            }
        }
    }
    
    
    // Category
    private func convertCategoryMapToObjectList(categoryMapList: Array<Any>) -> [CategoryObject] {
        var categorys = [CategoryObject]()
        for category in categoryMapList {
            if let categoryMap = category as? [String : Any] {
                var category = CategoryObject.init()
                category.id = categoryMap[AppConstants.ServerKey.ID] as? String ?? ""
                category.title = categoryMap[AppConstants.ServerKey.TITLE] as? String ?? ""
                category.imageName = categoryMap[AppConstants.ServerKey.IMAGE_NAME] as? String ?? ""
                category.adminId = categoryMap[AppConstants.ServerKey.ADMIN_ID] as? String ?? ""
                category.status = categoryMap[AppConstants.ServerKey.STATUS] as? String ?? ""
                
                categorys.append(category)
            }
        }
        return categorys
    }
    
    // Live TV
    private func convertLiveTvMapToObjectList(liveTvMapList: Array<Any>) -> [LiveTvObject] {
        var liveTvs = [LiveTvObject]()
        for liveTv in liveTvMapList {
            if let liveTvMap = liveTv as? [String : Any] {
                var liveTv = LiveTvObject.init()
                liveTv.id = liveTvMap[AppConstants.ServerKey.ID] as? String ?? ""
                liveTv.title = liveTvMap[AppConstants.ServerKey.TITLE] as? String ?? ""
                liveTv.imageName = liveTvMap[AppConstants.ServerKey.IMAGE_NAME] as? String ?? ""
                liveTv.adminId = liveTvMap[AppConstants.ServerKey.ADMIN_ID] as? String ?? ""
                liveTv.status = liveTvMap[AppConstants.ServerKey.STATUS] as? String ?? ""
                liveTv.link = liveTvMap[AppConstants.ServerKey.LINK] as? String ?? ""
                
                liveTvs.append(liveTv)
            }
        }
        return liveTvs
    }
    
    // Featured
    private func convertFeaturedMapToObjectList(featuredMapList: Array<Any>) -> [VideoObject] {
        var allFeatured = [VideoObject]()
        for featured in featuredMapList {
            if let featuredMap = featured as? [String : Any] {
                var featured = VideoObject.init()
                featured.id = featuredMap[AppConstants.ServerKey.ID] as? String ?? ""
                featured.category = featuredMap[AppConstants.ServerKey.CATEGORY] as? String ?? ""
                featured.adminId = featuredMap[AppConstants.ServerKey.ADMIN_ID] as? String ?? ""
                featured.status = featuredMap[AppConstants.ServerKey.STATUS] as? String ?? ""
                featured.title = featuredMap[AppConstants.ServerKey.TITLE] as? String ?? ""
                featured.description = featuredMap[AppConstants.ServerKey.DESCRIPTION] as? String ?? ""
                featured.imageName = featuredMap[AppConstants.ServerKey.IMAGE_NAME] as? String ?? ""
                featured.type = featuredMap[AppConstants.ServerKey.TYPE] as? String ?? ""
                featured.uploadedVideo = featuredMap[AppConstants.ServerKey.UPLOADED_VIDEO] as? String ?? ""
                featured.videoLink = featuredMap[AppConstants.ServerKey.VIDEO_LINK] as? String ?? ""
                featured.youtube = featuredMap[AppConstants.ServerKey.YOUTUBE] as? String ?? ""
                featured.vimeo = featuredMap[AppConstants.ServerKey.VIMEO] as? String ?? ""
                featured.featured = featuredMap[AppConstants.ServerKey.FEATURED] as? String ?? ""
                featured.viewCount = featuredMap[AppConstants.ServerKey.VIEW_COUNT] as? String ?? ""
                featured.imageResolution = featuredMap[AppConstants.ServerKey.IMAGE_RESOLUTION] as? String ?? ""
                featured.duration = featuredMap[AppConstants.ServerKey.DURATION] as? String ?? ""
                featured.created = featuredMap[AppConstants.ServerKey.CREATED] as? String ?? ""
                
                allFeatured.append(featured)
            }
        }
        return allFeatured
    }
    
    // Most popular
    private func convertPopularMapToObjectList(popularMapList: Array<Any>) -> [VideoObject] {
        var populars = [VideoObject]()
        for popular in popularMapList {
            if let popularMap = popular as? [String : Any] {
                var popular = VideoObject.init()
                popular.id = popularMap[AppConstants.ServerKey.ID] as? String ?? ""
                popular.category = popularMap[AppConstants.ServerKey.CATEGORY] as? String ?? ""
                popular.adminId = popularMap[AppConstants.ServerKey.ADMIN_ID] as? String ?? ""
                popular.status = popularMap[AppConstants.ServerKey.STATUS] as? String ?? ""
                popular.title = popularMap[AppConstants.ServerKey.TITLE] as? String ?? ""
                popular.description = popularMap[AppConstants.ServerKey.DESCRIPTION] as? String ?? ""
                popular.imageName = popularMap[AppConstants.ServerKey.IMAGE_NAME] as? String ?? ""
                popular.type = popularMap[AppConstants.ServerKey.TYPE] as? String ?? ""
                popular.uploadedVideo = popularMap[AppConstants.ServerKey.UPLOADED_VIDEO] as? String ?? ""
                popular.videoLink = popularMap[AppConstants.ServerKey.VIDEO_LINK] as? String ?? ""
                popular.youtube = popularMap[AppConstants.ServerKey.YOUTUBE] as? String ?? ""
                popular.vimeo = popularMap[AppConstants.ServerKey.VIMEO] as? String ?? ""
                popular.featured = popularMap[AppConstants.ServerKey.FEATURED] as? String ?? ""
                popular.viewCount = popularMap[AppConstants.ServerKey.VIEW_COUNT] as? String ?? ""
                popular.imageResolution = popularMap[AppConstants.ServerKey.IMAGE_RESOLUTION] as? String ?? ""
                popular.duration = popularMap[AppConstants.ServerKey.DURATION] as? String ?? ""
                popular.created = popularMap[AppConstants.ServerKey.CREATED] as? String ?? ""
                
                populars.append(popular)
            }
        }
        return populars
    }
    
    // Most recent
    private func convertRecentMapToObjectList(recentMapList: Array<Any>) -> [VideoObject] {
        var recents = [VideoObject]()
        for recent in recentMapList {
            if let recentMap = recent as? [String : Any] {
                var recent = VideoObject.init()
                recent.id = recentMap[AppConstants.ServerKey.ID] as? String ?? ""
                recent.category = recentMap[AppConstants.ServerKey.CATEGORY] as? String ?? ""
                recent.adminId = recentMap[AppConstants.ServerKey.ADMIN_ID] as? String ?? ""
                recent.status = recentMap[AppConstants.ServerKey.STATUS] as? String ?? ""
                recent.title = recentMap[AppConstants.ServerKey.TITLE] as? String ?? ""
                recent.description = recentMap[AppConstants.ServerKey.DESCRIPTION] as? String ?? ""
                //print(">>>>> DESCRIPTION >> \(recent)")
                recent.imageName = recentMap[AppConstants.ServerKey.IMAGE_NAME] as? String ?? ""
                recent.type = recentMap[AppConstants.ServerKey.TYPE] as? String ?? ""
                recent.uploadedVideo = recentMap[AppConstants.ServerKey.UPLOADED_VIDEO] as? String ?? ""
                recent.videoLink = recentMap[AppConstants.ServerKey.VIDEO_LINK] as? String ?? ""
                recent.youtube = recentMap[AppConstants.ServerKey.YOUTUBE] as? String ?? ""
                recent.vimeo = recentMap[AppConstants.ServerKey.VIMEO] as? String ?? ""
                recent.featured = recentMap[AppConstants.ServerKey.FEATURED] as? String ?? ""
                recent.viewCount = recentMap[AppConstants.ServerKey.VIEW_COUNT] as? String ?? ""
                recent.imageResolution = recentMap[AppConstants.ServerKey.IMAGE_RESOLUTION] as? String ?? ""
                recent.duration = recentMap[AppConstants.ServerKey.DURATION] as? String ?? ""
                recent.created = recentMap[AppConstants.ServerKey.CREATED] as? String ?? ""
                
                recents.append(recent)
            }
        }
        
        return recents
        
        //return Array(recents.prefix(100))
    }
    
    // Get all video by category
    private func convertVideoMapToObjectList(videoMapList: Array<Any>) -> [VideoObject] {
        var allVideos = [VideoObject]()
        for video in videoMapList {
            if let videoMap = video as? [String : Any] {
                var video = VideoObject.init()
                video.id = videoMap[AppConstants.ServerKey.ID] as? String ?? ""
                video.category = videoMap[AppConstants.ServerKey.CATEGORY] as? String ?? ""
                video.adminId = videoMap[AppConstants.ServerKey.ADMIN_ID] as? String ?? ""
                video.status = videoMap[AppConstants.ServerKey.STATUS] as? String ?? ""
                video.title = videoMap[AppConstants.ServerKey.TITLE] as? String ?? ""
                video.description = videoMap[AppConstants.ServerKey.DESCRIPTION] as? String ?? ""
                video.imageName = videoMap[AppConstants.ServerKey.IMAGE_NAME] as? String ?? ""
                video.type = videoMap[AppConstants.ServerKey.TYPE] as? String ?? ""
                video.uploadedVideo = videoMap[AppConstants.ServerKey.UPLOADED_VIDEO] as? String ?? ""
                video.videoLink = videoMap[AppConstants.ServerKey.VIDEO_LINK] as? String ?? ""
                video.youtube = videoMap[AppConstants.ServerKey.YOUTUBE] as? String ?? ""
                video.vimeo = videoMap[AppConstants.ServerKey.VIMEO] as? String ?? ""
                video.featured = videoMap[AppConstants.ServerKey.FEATURED] as? String ?? ""
                video.viewCount = videoMap[AppConstants.ServerKey.VIEW_COUNT] as? String ?? ""
                video.imageResolution = videoMap[AppConstants.ServerKey.IMAGE_RESOLUTION] as? String ?? ""
                video.duration = videoMap[AppConstants.ServerKey.DURATION] as? String ?? ""
                video.created = videoMap[AppConstants.ServerKey.CREATED] as? String ?? ""
                
                allVideos.append(video)
            }
        }
        return allVideos
    }
    
    
    // NSUser Defaults
    func setMyData(user: UserModel){
        let defaults = UserDefaults.standard
        
        //Set
        defaults.set(user.email, forKey: "myEmail")
        defaults.set(user.id, forKey: "myID")
        defaults.set(user.type, forKey: "myRegistrationType")
        defaults.set(user.username, forKey: "myUserName")
        
        getMyData()
    }
    
    func getMyData() -> UserModel {
        let defaults = UserDefaults.standard
        
        //Get
        var user = UserModel.init()
        let email = defaults.string(forKey: "myEmail")
        let id = defaults.string(forKey: "myID")
        let type = defaults.string(forKey: "myRegistrationType")
        let username = defaults.string(forKey: "myUserName")
        user.id =  id ?? ""
        user.email =  email ?? ""
        user.type = type ?? ""
        user.username = username ?? ""
        
        print("Saved user Data: \(user)")
        
        return user
    }
    
    // Remove user data
    func removeMyData(){
        let defaults = UserDefaults.standard
        
        //Remove
        defaults.removeObject(forKey: "myID")
        defaults.removeObject(forKey: "myEmail")
        defaults.removeObject(forKey: "myRegistrationType")
        defaults.removeObject(forKey: "myUserName")
        
        getMyData()
    }
    
    // Video duration seconds to hour:minutes:seconds calculator
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}

