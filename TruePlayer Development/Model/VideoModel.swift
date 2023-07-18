//
//  VideoModel.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 22/05/23.
//

import UIKit

class VideoModel : NSObject, Codable{
    
    var id : String?
    var title : String?
    var thumbnail : String?
    var videoUrl : String?
    var videoLength : Int?
    var mDescription : String?
    var categoryId : String?
    var dateCreated : Date?
    
}
