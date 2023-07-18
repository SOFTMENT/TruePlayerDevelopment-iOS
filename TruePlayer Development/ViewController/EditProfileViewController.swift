//
//  EditProfileViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 08/06/23.
//

import UIKit
import CropViewController
import Cloudinary

class EditProfileViewController : UIViewController {
    
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var mProfile: UIImageView!
    @IBOutlet weak var updateBtn: UIButton!
    var isImageSelected = false
    
    override func viewDidLoad() {
     
        
        mProfile.makeRounded()
        mProfile.isUserInteractionEnabled = true
        mProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadProfilePicClicked)))
        
        fullNameTF.delegate = self
        fullNameTF.text = UserModel.data!.fullName ?? ""
        
        if let path = UserModel.data!.profilePic, !path.isEmpty {
            mProfile.sd_setImage(with: URL(string: path), placeholderImage: UIImage(named: "profile-placeholder"))
        }
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        updateBtn.layer.cornerRadius = 8
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
    
    @IBAction func updateBtnClicked(_ sender: Any) {
        let sFullName = fullNameTF.text
        
        if sFullName == "" {
            self.showSnack(messages: "Enter Full Name")
        }
        else {
            ProgressHUDShow(text: "")
            UserModel.data?.fullName = sFullName
            if isImageSelected {
                uploadImageOnCloud(userId: UserModel.data!.uid ?? "123") { downloadURL in
                    UserModel.data!.profilePic = downloadURL
                    self.updateUser()
                }
            }
            else {
                updateUser()
            }
        }
    }
    
    func updateUser(){
        try? FirebaseStoreManager.db.collection("Users").document(UserModel.data!.uid ?? "123").setData(from: UserModel.data!,merge : true) { error in
            self.ProgressHUDHide()
            if let error = error {
                self.showError(error.localizedDescription)
            }
            else {
                self.showSnack(messages: "Profile Updated")
            }
        }
    }
}

extension EditProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
}



extension EditProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
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
            mProfile.image = image
        
       
        
            self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageOnCloud(userId : String,completion : @escaping (String?) -> Void ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                          return
        }
        let params = CLDUploadRequestParams()
        params.setPublicId(userId).setFolder("ProfilePicture")
    
        appDelegate.cloudinary!.createUploader().upload(data: self.mProfile.image!.jpegData(compressionQuality: 0.5)!, uploadPreset: "ml_default", params: params).progress { progress in
      
          
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
