//
//  TabBarViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 14/05/23.
//

import UIKit

class TabBarViewController : UITabBarController, UITabBarControllerDelegate {
  
    var tabBarItems = UITabBarItem()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate  = self
        
        
        let selectedImage1 = UIImage(named: "Mask group-4")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = deSelectedImage1
        tabBarItems.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "Mask group-3")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "activity")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![1]
        tabBarItems.image = deSelectedImage2
        tabBarItems.selectedImage = selectedImage2
        
        let selectedImage3 = UIImage(named: "Mask group-1")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "calendar")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![2]
        tabBarItems.image = deSelectedImage3
        tabBarItems.selectedImage = selectedImage3
        
        
        let selectedImage4 = UIImage(named: "Mask group")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage4 = UIImage(named: "graph")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![3]
        tabBarItems.image = deSelectedImage4
        tabBarItems.selectedImage = selectedImage4
        
        
        let selectedImage5 = UIImage(named: "Mask group-2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage5 = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![4]
        tabBarItems.image = deSelectedImage5
        tabBarItems.selectedImage = selectedImage5
        
        
        
        
    }
    
}


