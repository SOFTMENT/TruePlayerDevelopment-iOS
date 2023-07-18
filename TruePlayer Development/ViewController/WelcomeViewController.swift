//
//  WelcomeViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 13/05/23.
//


import UIKit

class WelcomeViewController :  UIViewController {
    
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        
        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
            //if app is first time opened then it will be nil
            userDefaults.setValue(true, forKey: "appFirstTimeOpend")
            
            //SUBSCRIBE TO TOPIC
            FirebaseStoreManager.messaging.subscribe(toTopic: "trueplayer")
            
            // signOut from FIRAuth
            do {
                
                try FirebaseStoreManager.auth.signOut()
            }catch {
                
            }
            // go to beginning of app
        }
        
        
        
        
        if FirebaseStoreManager.auth.currentUser != nil {
            
            self.getUserData(uid:FirebaseStoreManager.auth.currentUser!.uid, showProgress: false)
            
            
        }
        else {
            
            self.gotoSignInViewController()
            
        }
        
        
        
        
    }
    
    func gotoSignInViewController(){
        DispatchQueue.main.async {
            self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
        }
    }
    
}
