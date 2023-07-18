//
//  SignUpViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 13/05/23.
//

import UIKit
import Cloudinary
import CropViewController

class SignUpViewController : UIViewController {
    
    var isImageSelected = false
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var emailAddress: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var loginBtn: UILabel!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        
        registerBtn.layer.cornerRadius = 8
    
        profilePic.makeRounded()
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadProfilePicClicked)))
        
        fullName.delegate = self
        emailAddress.delegate = self
        password.delegate = self
        teamName.delegate = self
        
        loginBtn.isUserInteractionEnabled = true
        loginBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        backView.layer.cornerRadius = 8
        backView.dropShadow()
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    
    @objc func uploadProfilePicClicked() {
        
        chooseImageFromPhotoLibrary()
    }
    
    func chooseImageFromPhotoLibrary(){
        
        let alert = UIAlertController(title: "Upload Profile Picture", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Using Camera", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.title = "Profile Picture"
            image.delegate = self
            image.sourceType = .camera
            self.present(image,animated: true)
            
            
        }
        
        let action2 = UIAlertAction(title: "From Photo Library", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.delegate = self
            image.title = "Profile Picture"
            image.sourceType = .photoLibrary
            
            self.present(image,animated: true)
            
            
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        self.present(alert,animated: true,completion: nil)
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true)
    }
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        
        let sFullname = fullName.text
        let sEmail = emailAddress.text
        let sPassword = password.text
        _ = teamName.text
        
        if !isImageSelected {
            self.showSnack(messages: "Upload Profile Picture")
        }
        else if sFullname == "" {
            self.showSnack(messages: "Enter Fullname")
        }
        else if sEmail == "" {
            self.showSnack(messages: "Enter Email Address")
        }
        else if sPassword == "" {
            self.showSnack(messages: "Enter Password")
        }
    
        else {
            ProgressHUDShow(text: "Creating Account...")
            
            FirebaseStoreManager.auth.createUser(withEmail: sEmail!, password: sPassword!) { result, error in
                if let error = error {
                    self.ProgressHUDHide()
                    self.showError(error.localizedDescription)
                }
                else {
                    let userModel = UserModel()
                    userModel.email = sEmail!
                    userModel.fullName = sFullname!
                    userModel.uid = FirebaseStoreManager.auth.currentUser!.uid
                    userModel.registredAt = Date()
                    userModel.regiType = "custom"
                    
                    
                    self.uploadImageOnCloud(userId: FirebaseStoreManager.auth.currentUser!.uid) { downloadURL in
                       
                  
                        if let downloadURL = downloadURL {
                            userModel.profilePic = downloadURL
                        }
                           
                        self.addUserData(userData: userModel)
                           
                            
                        
                        
                    }
                }
                
            }
            
        }
        
    }
    
}

extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.originalImage] as? UIImage {
            
            self.dismiss(animated: true) {
                
                let cropViewController = CropViewController(image: editedImage)
                cropViewController.title = picker.title
                cropViewController.delegate = self
                cropViewController.customAspectRatio = CGSize(width: 1  , height: 1)
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.aspectRatioPickerButtonHidden = true
                self.present(cropViewController, animated: true, completion: nil)
            }
 
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
            isImageSelected = true
            profilePic.image = image
            self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageOnCloud(userId : String,completion : @escaping (String?) -> Void ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                          return
        }
        let params = CLDUploadRequestParams()
        params.setPublicId(userId).setFolder("ProfilePicture")
    
        appDelegate.cloudinary!.createUploader().upload(data: self.profilePic.image!.jpegData(compressionQuality: 0.5)!, uploadPreset: "ml_default", params: params).progress { progress in
      
          
        }.response { result, error in
           
            if error != nil {
               
                print(error!.localizedDescription)
                completion(nil)
                
            }
            else {
                completion(result!.secureUrl)
            }
            
        }
        
    }
    
    
}
