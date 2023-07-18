//
//  UserModel.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 13/05/23.
//


import UIKit

class UserModel : NSObject, Codable {
   

    var fullName : String?
    var email : String?
    var uid : String?
    var registredAt : Date?
    var regiType : String?
    var profilePic : String?
    
    
    
    private static var userData : UserModel?
    
    static func clearUserData() {
        self.userData = nil
    }
    
    static var data : UserModel? {
        set(userData) {
            if self.userData == nil {
                self.userData = userData
            }
        
            
        }
        get {
            return userData
        }
    }


    override init() {
        
    }
    
}
