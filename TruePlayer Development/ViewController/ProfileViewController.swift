//
//  ProfileViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 26/05/23.
//

import UIKit
import StoreKit
import Cloudinary
import RevenueCat

class ProfileViewController : UIViewController {
    
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var logoutView: UIButton!
    @IBOutlet weak var mProfile: UIImageView!
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var mEmail: UILabel!
    @IBOutlet weak var proView: UIView!
    @IBOutlet weak var membershipView: UIView!
    @IBOutlet weak var newsAndUpdateView: UIView!
    @IBOutlet weak var myWorkoutView: UIView!
    @IBOutlet weak var workoutReminders: UIView!
    @IBOutlet weak var submitVideosView: UIView!
    @IBOutlet weak var helpCenterView: UIView!
    @IBOutlet weak var rateAppView: UIView!
    @IBOutlet weak var shareAppView: UIView!
    @IBOutlet weak var deleteAccountView: UIView!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var privacyPolicyView: UIView!
    @IBOutlet weak var termsOfUseView: UIView!
    
    
    override func viewDidLoad() {
        
        mProfile.makeRounded()


        guard let user = UserModel.data else {
            DispatchQueue.main.async {
                self.logout()
            }
            return
        }
    
        editProfileBtn.layer.cornerRadius = 8
        
     
        
        proView.layer.cornerRadius = 6
  
        rateAppView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rateAppBtnClicked)))
        shareAppView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inviteFriendBtnClicked)))
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        version.text  = "\(appVersion ?? "1.0")"
        
        privacyPolicyView.isUserInteractionEnabled = true
        privacyPolicyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToPrivacyPolicy)))
        
        termsOfUseView.isUserInteractionEnabled = true
        termsOfUseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToTermsOfService)))
        
        logoutView.addBorderColourAndRadius()
     
        
        //NotificationCentre
        newsAndUpdateView.isUserInteractionEnabled = true
        newsAndUpdateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notificationBtnClicked)))
        
        //HelpCentre
        helpCenterView.isUserInteractionEnabled = true
        helpCenterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(helpCentreBtnClicked)))
        
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if customerInfo?.entitlements.all["Premium"]?.isActive == true {
                self.membershipView.isHidden = true
            }
            else {
                self.membershipView.isHidden = false
                
            }
        }
        membershipView.layer.cornerRadius = 8
        membershipView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goPremiumClicked)))
        
       
        //DELETE ACCOUNT
        
        deleteAccountView.isUserInteractionEnabled = true
        deleteAccountView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteAccountBtnClicked)))
               
   
        workoutReminders.isUserInteractionEnabled = true
        workoutReminders.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(workoutReminderClicked)))
        
        myWorkoutView.isUserInteractionEnabled = true
        myWorkoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myWorkoutClicked)))
        
        submitVideosView.isUserInteractionEnabled = true
        submitVideosView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(submitVideoClicked)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mName.text = UserModel.data!.fullName
        mEmail.text = UserModel.data!.email
        
        if let image = UserModel.data!.profilePic, image != "" {
            mProfile.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profile-placeholder"), options: .continueInBackground, completed: nil)
        }
    }
    
    @objc func submitVideoClicked(){
        let alert = UIAlertController(title: "Upload Video", message: "Upload your video and get a chance to select for weekly highlight.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Choose Video", style: .default,handler: { action in
            self.uploadVideoClicked()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func myWorkoutClicked(){
        if let tab  = tabBarController as? TabBarViewController {
            tab.selectedIndex = 3
        }
    }
    @objc func workoutReminderClicked(){
        if let tab  = tabBarController as? TabBarViewController {
            tab.selectedIndex = 2
        }
    }
    
    @objc func deleteAccountBtnClicked(){
        let alert = UIAlertController(title: "DELETE ACCOUNT", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            
            if let user = FirebaseStoreManager.auth.currentUser {
                
                self.ProgressHUDShow(text: "Account Deleting...")
                let userId = user.uid
                
                FirebaseStoreManager.db.collection("Users").document(userId).delete { error in
                           
                            if error == nil {
                                user.delete { error in
                                    self.ProgressHUDHide()
                                    if error == nil {
                                        self.logout()
                                        
                                    }
                                    else {
                                        self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
                                    }
    
                                
                                }
                                
                            }
                            else {
                       
                                self.showError(error!.localizedDescription)
                            }
                        }
                    
                }
            
            
        }))
        present(alert, animated: true)
    }
       
    @objc func goPremiumClicked(){
        
        self.performSegue(withIdentifier: "profileMembershipSeg", sender: nil)
        
    }
    

   
    @objc func uploadVideoClicked(){
        let image = UIImagePickerController()
        image.delegate = self
        image.title = title
        image.mediaTypes = ["public.movie"]
        image.sourceType = .photoLibrary
        self.present(image,animated: true)
    }
  
    
    @objc func helpCentreBtnClicked(){
        
    
        if let url = URL(string: "mailto:trueplayerdev@gmail.com") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    @objc func notificationBtnClicked(){
        performSegue(withIdentifier: "settings_notificationSeg", sender: nil)
    }
    
    

    
    @IBAction func editProfileClicked(_ sender: Any) {
        
            performSegue(withIdentifier: "updateProfileSeg", sender: nil)
    }
    
    
    
    
    @objc func redirectToTermsOfService() {
        
        guard let url = URL(string: "https://softment.in/terms-of-service/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func redirectToPrivacyPolicy() {
        
        guard let url = URL(string: "https://softment.in/privacy-policy/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func inviteFriendBtnClicked(){
        
        let someText:String = "Check Out TruePlayer Development App."
        let objectsToShare:URL = URL(string: "https://apps.apple.com/us/app/trueplayer-development/id6449164737?ls=1&mt=8")!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func rateAppBtnClicked(){
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "6449164737") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func logoutClicked(_ sender: Any) {
        let alert = UIAlertController(title: "LOGOUT", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
            self.logout()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    



   
}


extension ProfileViewController  : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        

        let videoPath = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaURL.rawValue)] as? URL
        let id = FirebaseStoreManager.db.collection("WeeklyVideos").document().documentID
        
        self.uploadVideoOnCloud(videoPath: videoPath!, id: id) { downloadURL, duration in
            if let downloadURL = downloadURL, !downloadURL.isEmpty {
                self.ProgressHUDShow(text: "")
                let highlightModel = HighlightModel()
                highlightModel.id = id
                highlightModel.videoUrl = downloadURL
                highlightModel.userName = UserModel.data!.fullName ?? ""
                highlightModel.videoLength = Int(duration)
                highlightModel.addedDate = Date()
                highlightModel.thumbnail = downloadURL.replacingOccurrences(of: ".mp4", with: ".jpg")
                
                try? FirebaseStoreManager.db.collection("WeeklyVideos").document(id).setData(from: highlightModel) { error in
                    if let error = error {
                        self.showError(error.localizedDescription)
                    }
                    else {
                        self.showMessage(title: "Uploaded", message: "hank You! We have received your video and we will review this for weekly highlight.")
                    }
                }
            }
            else {
                self.showSnack(messages: "Upload Failed")
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadVideoOnCloud(videoPath : URL,id : String,completion : @escaping (String?, Double) -> Void ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                          return
        }
        let params = CLDUploadRequestParams()
        
        params.setPublicId(id).setFolder("WeeklyVideos").setResourceType("video")
        let loading = self.DownloadProgressHUDShow(text: "Video Uploading : 0.0%")
        appDelegate.cloudinary!.createUploader().upload(url: videoPath, uploadPreset: "ml_default", params: params).progress { progress in
            self.DownloadProgressHUDUpdate(loading: loading, text: "Video Uploading : \(String(format: "%.2f", progress.fractionCompleted * 100))%")
          
        }.response { result, error in
            self.ProgressHUDHide()
            if error != nil {
               
                completion(nil, -1)
                
            }
            else {
                completion(result!.secureUrl, result!.length ?? 0)
            }
            
        }
 
    }

}
