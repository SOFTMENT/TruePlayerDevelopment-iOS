//
//  MembershipViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 26/05/23.
//

import UIKit
import RevenueCat

class MembershipViewController : UIViewController {
    
    
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var activateNowBtn: UIButton!
   
    @IBOutlet weak var termsOfUse: UILabel!
    @IBOutlet weak var privacyPolicy: UILabel!
    
    override func viewDidLoad() {
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        activateNowBtn.layer.cornerRadius = 8
        mImage.layer.cornerRadius = 8
        
        privacyPolicy.isUserInteractionEnabled = true
        privacyPolicy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToPrivacyPolicy)))
        
        termsOfUse.isUserInteractionEnabled = true
        termsOfUse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToTermsOfService)))
        
    }
    
    
    
    @objc func redirectToTermsOfService() {
        
        guard let url = URL(string: "https://softment.in/terms-of-service/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func redirectToPrivacyPolicy() {
        
        guard let url = URL(string: "https://softment.in/privacy-policy/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true)
    }
    
    @IBAction func activateNowBtnClicked(_ sender: Any) {
        Purchases.shared.getOfferings { (offerings, error) in
            if let offerings = offerings {
                var package : Package?
                package = offerings.current?.availablePackages[0]
                self.ProgressHUDShow(text: "")
         
                Purchases.shared.purchase(package: package!) { (transaction, customerInfo, error, userCancelled) in
                    self.ProgressHUDHide()
                    if let error = error {
                        self.ProgressHUDHide()
                        self.showError(error.localizedDescription)
                    }
                    else {
                        
                        if customerInfo?.entitlements.all["Premium"]?.isActive == true {
                            let alert = UIAlertController(title: "Membership Purchased", message: "Your account membership has been successully upgraded. Thank You", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dashboard", style: .default, handler: { action in
                                self.beRootScreen(mIdentifier: Constants.StroyBoard.tabBarViewController)
                            }))
                            self.present(alert, animated: true)
                            
                        }
                        
                    }
                }
            }
        }
    }
}
