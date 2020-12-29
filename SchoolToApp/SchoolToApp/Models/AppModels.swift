//
//  AppModels.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//


import Foundation

struct UserModel: Codable {
    var email: String = ""
    var id: String = ""
    var type: String = ""
    var username: String = ""
}


struct ResponseModel {
    var status: Int = 0
    var message: String = ""
    var data: Any?
}


struct CategoryObject {
    var id: String = ""
    var adminId: String = ""
    var status: String = ""
    var title: String = ""
    var imageName: String = ""
    
}

struct LiveTvObject {
    var id: String = ""
    var adminId: String = ""
    var status: String = ""
    var title: String = ""
    var imageName: String = ""
    var link: String = ""
    
}

struct SuggestedLiveTvObject {
    var id: String = ""
    var adminId: String = ""
    var status: String = ""
    var title: String = ""
    var imageName: String = ""
    var link: String = ""
    
}

struct FeaturedObject {
    var id: String = ""
    var category: String = ""
    var adminId: String = ""
    var status: String = ""
    var title: String = ""
    var description: String = ""
    var imageName: String = ""
    var type: String = ""
    var uploadedVideo: String = ""
    var youtube: String = ""
    var vimeo: String = ""
    var featured: String = ""
    var viewCount: String = ""
    var imageResolution: String = ""
    var duration: String = ""
}

struct MostPopluarObject {
    var id: String = ""
    var category: String = ""
    var adminId: String = ""
    var status: String = ""
    var title: String = ""
    var description: String = ""
    var imageName: String = ""
    var type: String = ""
    var uploadedVideo: String = ""
    var youtube: String = ""
    var vimeo: String = ""
    var featured: String = ""
    var viewCount: String = ""
    var imageResolution: String = ""
    var duration: String = ""
}

struct MostRecentObject {
    var id: String = ""
    var category: String = ""
    var adminId: String = ""
    var status: String = ""
    var title: String = ""
    var description: String = ""
    var imageName: String = ""
    var type: String = ""
    var uploadedVideo: String = ""
    var youtube: String = ""
    var vimeo: String = ""
    var featured: String = ""
    var viewCount: String = ""
    var imageResolution: String = ""
    var duration: String = ""
}

struct SuggestedVideoObject {
    var id: String = ""
    var category: String = ""
    var adminId: String = ""
    var status: String = ""
    var title: String = ""
    var description: String = ""
    var imageName: String = ""
    var type: String = ""
    var uploadedVideo: String = ""
    var youtube: String = ""
    var vimeo: String = ""
    var featured: String = ""
    var viewCount: String = ""
    var imageResolution: String = ""
    var duration: String = ""
}

struct VideosByCategoryObject {
    var id: String = ""
    var category: String = ""
    var adminId: String = ""
    var status: String = ""
    var title: String = ""
    var description: String = ""
    var imageName: String = ""
    var type: String = ""
    var uploadedVideo: String = ""
    var youtube: String = ""
    var vimeo: String = ""
    var featured: String = ""
    var viewCount: String = ""
    var imageResolution: String = ""
    var duration: String = ""
}

struct VideoObject {
    var id: String = ""
    var category: String = ""
    var adminId: String = ""
    var status: String = ""
    var title: String = ""
    var description: String = ""
    var imageName: String = ""
    var type: String = ""
    var uploadedVideo: String = ""
    var youtube: String = ""
    var vimeo: String = ""
    var videoLink: String = ""
    var featured: String = ""
    var viewCount: String = ""
    var imageResolution: String = ""
    var duration: String = ""
    var created: String = ""
}
struct VideoObject2 {
    var id: String = ""
    var category: String = ""
    var adminId: String = ""
    var status: String = ""
    var title: String = ""
    var description: String = ""
    var imageName: String = ""
    var type: String = ""
    var uploadedVideo: String = ""
    var youtube: String = ""
    var vimeo: String = ""
    var featured: String = ""
    var viewCount: String = ""
    var imageResolution: String = ""
    var duration: String = ""
    var created: String = ""
}
