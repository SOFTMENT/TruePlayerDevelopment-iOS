//
//  SignInViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 13/05/23.
//

import UIKit
import AuthenticationServices
import CryptoKit
import Firebase

fileprivate var currentNonce: String?
class SignInViewController : UIViewController {
    
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var googleBtn: UIView!
    @IBOutlet weak var appleBtn: UIView!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var reset: UILabel!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var registration: UILabel!
    
    
    override func viewDidLoad() {
        
        reset.isUserInteractionEnabled = true
        reset.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgotPasswordClicked)))
        
        
        
        logo.layer.cornerRadius = 8
        googleBtn.layer.cornerRadius = 8
        googleBtn.isUserInteractionEnabled = true
        googleBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginWithGoogleBtnClicked)))
        
        
        appleBtn.layer.cornerRadius = 8
        appleBtn.isUserInteractionEnabled = true
        appleBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginWithAppleBtnClicked)))
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
        continueBtn.layer.cornerRadius = 8
        
        registration.isUserInteractionEnabled = true
        registration.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(registerBtnClicked)))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidekeyboard)))
    }
    
    @objc func registerBtnClicked(){
        performSegue(withIdentifier: "signUpSeg", sender: nil)
    }
    
    @objc func forgotPasswordClicked() {
        let sEmail = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sEmail == "" {
            showSnack(messages: "Enter Email Address")
        }
        else {
            ProgressHUDShow(text: "")
            FirebaseStoreManager.auth.sendPasswordReset(withEmail: sEmail!) { error in
                self.ProgressHUDHide()
                if error == nil {
                    self.showMessage(title: "RESET PASSWORD", message: "We have sent reset password link on your mail address.", shouldDismiss: false)
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
    }
    
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        let sEmail = emailTF.text?.trimmingCharacters(in: .nonBaseCharacters)
        let sPassword = passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sEmail == "" {
            showSnack(messages: "Enter Email Address")
        }
        else if sPassword == "" {
            showSnack(messages: "Enter Password")
        }
        else {
            ProgressHUDShow(text: "")
            FirebaseStoreManager.auth.signIn(withEmail: sEmail!, password: sPassword!) { authResult, error in
                self.ProgressHUDHide()
                if error == nil {
                
                    if let user = FirebaseStoreManager.auth.currentUser {
                        self.getUserData(uid: user.uid, showProgress: true)
                    }

                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
 
    }
    
    @objc func hidekeyboard(){
        view.endEditing(true)
    }
    
 
    
    @objc func loginWithGoogleBtnClicked() {
        self.loginWithGoogle()
    }
    
    @objc func loginWithAppleBtnClicked(){
     
        self.startSignInWithAppleFlow()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    

    
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        // authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
   
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    

    
}

extension SignInViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hidekeyboard()
        return true
    }
}


extension SignInViewController : ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            var displayName = "TruePlayer Developmemt"
           
            
            if let fullName = appleIDCredential.fullName {
                if let firstName = fullName.givenName {
                    displayName = firstName
                }
                if let lastName = fullName.familyName {
                    displayName = "\(displayName) \(lastName)"
                }
            }
            
            authWithFirebase(credential: credential, type: "apple",displayName: displayName)
            
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        
        print("Sign in with Apple errored: \(error)")
    }
    
}
