//
//  HighlightModel.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 22/05/23.
//

import UIKit

class HighlightModel : NSObject, Codable{
    
    var id : String?
    var userName : String?
    var thumbnail : String?
    var videoUrl : String?
    var videoLength : Int?
    var addedDate : Date?
    var selected : Bool?
    
}
