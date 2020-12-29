//
//  ServerMapper.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//

import Foundation

//"baseUrl": "http://3.138.134.200/BackToSchool/public/",
//"fileUrl": "http://3.138.134.200/BackToSchool/public/uploads/",
//"thumbUrl": "http://3.138.134.200/BackToSchool/public/uploads/thumb/",


class ServerMapper {
    
    // Get Category Request Info
    static func getCategoryRequestInfo(page: Int) -> (url: String, param: [String: Any] ) {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/category/all.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        
        // For pagination uncomment the line below
        //param[AppConstants.ServerKey.PAGE] = page
        return (url, param)
    }
    
    // Get Live Tv Request Info
    static func getLiveTvRequestInfo(page: Int) -> (url: String, param: [String: Any] ) {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/livetv/all.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        //param[AppConstants.ServerKey.PAGE] = page
        return (url, param)
    }
    
    // Get Featured Request Info
    static func getFeaturedRequestInfo(page: Int) -> (url: String, param: [String: Any] ) {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/video/featured.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        //param[AppConstants.ServerKey.PAGE] = page
        return (url, param)
    }
    
    // Get Popular Request Info
    static func getPopularRequestInfo(page: Int) -> (url: String, param: [String: Any] ) {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/video/popular.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        //param[AppConstants.ServerKey.PAGE] = page
        return (url, param)
    }
    
    // Get Recent Request Info
    static func getRecentRequestInfo(page: Int) -> (url: String, param: [String: Any] ) {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/video/recent.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        //param[AppConstants.ServerKey.PAGE] = page
        return (url, param)
    }
    
    // Get Category Wise Video Request Info
    static func getCategoryWiseVideoRequestInfo(page: Int, category:Int) -> (url: String, param: [String: Any] ) {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/video/by-category.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        //param[AppConstants.ServerKey.PAGE] = page
        param[AppConstants.ServerKey.CATEGORY] = category
        return (url, param)
    }
    
    // Get Search Video Request Info
    static func getSearchVideoRequestInfo(searchText:String) -> (url: String, param: [String: Any] ) {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/video/search.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.SEARCH] = searchText
        // param[AppConstants.ServerKey.PAGE] = page
        return (url, param)
    }
    
    // Get Suggested Video Request Info
    static func getSuggestedVideoRequestInfo(page: Int, id: Int) -> (url: String, param: [String: Any] ) {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/video/suggested.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.ID] = id
        //param[AppConstants.ServerKey.PAGE] = page
        return (url, param)
    }
    
    
    // Register a new user to server
    static func signUpUserInfo(type:Int, socialId: String, name: String, email: String, password: String) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/user/register.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.TYPE] = type
        param[AppConstants.ServerKey.SOCIAL_ID] = socialId
        param[AppConstants.ServerKey.USERNAME] = name
        param[AppConstants.ServerKey.EMAIL] = email
        param[AppConstants.ServerKey.PASSWORD] = password
        
        
        return (url, param)
    }
    
    // Login a new user
    static func loginUserInfo(email: String, password: String) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/user/login.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.EMAIL] = email
        param[AppConstants.ServerKey.PASSWORD] = password
        return (url, param)
    }
    
    // Email verification
    static func emailVerificationInfo(email: String, verificationToken: String) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/user/email-verification.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.EMAIL] = email
        param[AppConstants.ServerKey.VERIFICATION_TOKEN] = verificationToken
        return (url, param)
    }
    
    // Update password
    static func updatePasswordInfo(email: String, verificationToken: String, password: String) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/user/update-password.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.EMAIL] = email
        param[AppConstants.ServerKey.VERIFICATION_TOKEN] = verificationToken
        param[AppConstants.ServerKey.PASSWORD] = password
        return (url, param)
    }
    
    // Send Code
    static func sendCodeInfo(email:String) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/user/send-code.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.EMAIL] = email
        return (url, param)
    }
    
    // Settings info
    static func settingInfo() -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/settings/setting.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        return (url, param)
    }
    
    // Admob info
    static func admobInfo() -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/admobs/admob.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        return (url, param)
    }
    
    // Add to favourite info
    static func addFavouriteInfo(userId: Int, videoId: Int) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/favourite/add.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.USER_ID] = userId
        param[AppConstants.ServerKey.VIDEO_ID] = videoId
        return (url, param)
    }
    
    // Remove from favourite
    static func removeFavouriteInfo(userId: Int, videoId: Int) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/favourite/remove.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.VIDEO_ID] = videoId
        param[AppConstants.ServerKey.USER_ID] = userId
        return (url, param)
    }
    
    // All Favourite By User
    static func getAllFavouriteByUserInfo(userId: Int) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/favourite/by-user.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.USER_ID] = userId
        //param[AppConstants.ServerKey.PAGE] = page
        return (url, param)
    }
    
    // Add to play list
    static func addPlayListInfo(videoId: Int, userId: Int) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/playlist/add.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.VIDEO_ID] = videoId
        param[AppConstants.ServerKey.USER_ID] = userId
        //param[AppConstants.ServerKey.PAGE] = page
        return (url, param)
    }
    
    // Remove from play list
    static func removePlayListInfo(userId: Int, videoId: Int) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/playlist/remove.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.USER_ID] = userId
        param[AppConstants.ServerKey.VIDEO_ID] = videoId
        return (url, param)
    }
    
    // Get All Playlist By User
    static func getAllPlaylistByUserInfo(userId:Int, page:Int) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/playlist/by-user.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.USER_ID] = userId
    
        return (url, param)
    }
    
    // Add Review Info
    static func addReviewInfo(videoId: Int, userId:Int, rating:Int, review: String) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/review/add.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.VIDEO_ID] = videoId
        param[AppConstants.ServerKey.USER_ID] = userId
        param[AppConstants.ServerKey.RATING] = rating
        param[AppConstants.ServerKey.REVIEW] = review
        return (url, param)
    }
    
    // Remove Review Info
    static func removeReviewInfo(userId: String, videoId: String) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/review/remove.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.USER_ID] = userId
        param[AppConstants.ServerKey.VIDEO_ID] = videoId
        
        return (url, param)
    }
    
    // Get All Review By UserInfo
    static func getAllReviewByUserInfo(userId: Int) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/review/by-user.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.USER_ID] = userId
        return (url, param)
    }
    
    // Add View Count Info
    static func addViewCountInfo(videoId: Int) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/video/add-view-count.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.ID] = videoId
        return (url, param)
    }
    
    // Check Video Info
    static func checkVideoInfo(videoId: Int, userID: Int) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/video/check-video.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.VIDEO_ID] = videoId
        param[AppConstants.ServerKey.USER_ID] = userID
        return (url, param)
    }
    
    // Update Profile Info
    static func updateProfileInfo(id: Int, email: String, username: String, password: String, newPassword: String) -> (url: String, param: [String: Any] )
    {
        let credentials = CredentialGenerator.getBaseCredentials()
        let url = credentials.baseUrl + "api/user/update-profile.php"
        print(url)
        var param = [String: Any]()
        param[AppConstants.ServerKey.API_TOKEN] = "www"
        param[AppConstants.ServerKey.ID] = id
        param[AppConstants.ServerKey.EMAIL] = email
        param[AppConstants.ServerKey.USER_NAME] = username
        param[AppConstants.ServerKey.PASSWORD] = password
        param[AppConstants.ServerKey.NEW_PASSWORD] = newPassword
        return (url, param)
    }
}
