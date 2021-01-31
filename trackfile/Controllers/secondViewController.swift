//
//  secondViewController.swift
//  NOBIS2020
//
//  Created by Henit Work on 09/01/21.
//

import UIKit
import Canvas
import Firebase
import FirebaseAuth
import GoogleSignIn
import CryptoKit
import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit


class secondViewController: UIViewController {
    
   
    
    

    
    //MARK: - OUTLETS INTRODUCTION
    fileprivate var currentNonce: String?
    
    @IBOutlet weak var logoview: CSAnimationView!
    @IBOutlet weak var onlylogo: CSAnimationView!
    @IBOutlet weak var mainwindow: CSAnimationView!
    @IBOutlet weak var loginbutton: UIButton!
    @IBOutlet weak var emailtextfeild: UITextField!
    @IBOutlet weak var passwordtextfeild: UITextField!
    @IBOutlet weak var emailback: UIImageView!
    @IBOutlet weak var passwordback: UIImageView!
    @IBOutlet weak var border: UILabel!
    @IBOutlet weak var googlea: CSAnimationView!
    @IBOutlet weak var applea: CSAnimationView!
    @IBOutlet weak var appleLogoAnimationView: CSAnimationView!
    @IBOutlet weak var facebookAnimationView: CSAnimationView!
    @IBOutlet weak var loginbackground: UIImageView!
    
    
    
    
    //MARK: - Provider Signup Data
    
    var sname = ""
    var semail = ""
    var sphone = ""
   

    //MARK: - View Did Load
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.loginbackground.layer.cornerRadius = 30
        self.loginbutton.layer.cornerRadius = 15
        border.layer.borderWidth = 1
        border.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        border.layer.cornerRadius = 30
//        glow.layer.cornerRadius = 40
        emailtextfeild.attributedPlaceholder = NSAttributedString(string: "           ENTER YOUR EMAIL",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordtextfeild.attributedPlaceholder = NSAttributedString(string: "              ENTER YOUR PASSWORD",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        
       
        
        DispatchQueue.main.async {
            Settings.appID = "767367063919389"
            self.emailback.layer.cornerRadius = 15
            self.passwordback.layer.cornerRadius = 15
            
            self.animation(for: self.logoview, type: "slideUp", delay: 0.5, duration: 0.5)
            self.animation(for: self.onlylogo, type: "slideDown", delay: 0.5, duration: 0.5)
            self.animation(for: self.mainwindow, type: "zoomOut", delay: 1, duration: 1)
            self.animation(for: self.facebookAnimationView, type: "slideLeft", delay: 1.7, duration: 1.3)
            self.animation(for: self.googlea, type: "slideRight", delay: 1.7, duration: 1.3)
            self.animation(for: self.appleLogoAnimationView, type: "zoomOut", delay: 1.7, duration: 1.3)
            
        }
        
        passwordtextfeild.delegate = self
        emailtextfeild.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)


//MARK: - Base Func
        
        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func animation(for anima: CSAnimationView ,type : String,delay : TimeInterval ,duration : TimeInterval ){
        anima.type = type
        anima.delay = delay
        anima.duration = duration
        anima.startCanvasAnimation()
    }
    

    //MARK: - Sign IN with Email
    
    @IBAction func loginwithmail(_ sender: UIButton) {
        let email = emailtextfeild.text!
        let password = passwordtextfeild.text!
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            if error != nil {
                print("Sign IN successfull")
            }
            
          // ...
        }
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: - google sign in init.
    
    @IBAction func googlesignin(_ sender: GIDSignInButton) {
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
       
        
       
        
    }
//MARK: - facebook sign in control flow
    
    
    @IBAction func facebookloginsystem(_ sender: UIButton) {
        facebooklogin()
        
    }
    
    
    
    func facebooklogin() {
        let fbLoginManager : LoginManager = LoginManager()
//        fbLoginManager.logIn(permissions:["email"] , from: self, handler: { (result, error) -> Void in
//
//            print("\n\n result: \(String(describing: result))")
//            print("\n\n Error: \(String(describing: error))")
//
//          if (error == nil) {
//            let fbloginresult : LoginManagerLoginResult = result!
//            if(fbloginresult.isCancelled) {
//               //Show Cancel alert
//            } else if(fbloginresult.grantedPermissions.contains("email")) {
//                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
//
//                Auth.auth().signIn(with: credential) { (authResult, error) in
//                            if let error = error {
//                                print("authentication error \(error.localizedDescription)")
//                            }
//                        }
//
//
//                //fbLoginManager.logOut()
//            }
//           }
//         })
        fbLoginManager.logIn(permissions: ["email"], from: self) { ( result , error) in
            if error != nil {
                print(error?.localizedDescription as Any)
    
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            
    
            Auth.auth().signIn(with: credential) { (authResult, error) in
                        if let error = error {
                            print("authentication error \(error.localizedDescription)")
                        }
             
//                print(authResult?.user.displayName)
//                print(authResult?.user.email)
                

                }
               
    
        }
           
                    

        }

        


    
    
    
    
    
    
//MARK: - apple sign in control flow
    
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
    
    func performSignIn(){
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest{
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName , .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
    }
    
    @objc func handleSignInWithAppleTapped(){
        performSignIn()
    }
    
    @IBAction func developAppleSignIn(_ sender: UIButton) {
        performSignIn()
    }
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }

}
 


//MARK: - Textfeild delegate




extension secondViewController : UITextFieldDelegate {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailtextfeild.hasText{
            let k = isValidEmail(emailtextfeild.text!)
            
            if k == true{
                if emailtextfeild.hasText && passwordtextfeild.hasText{
                    textField.resignFirstResponder()
                    
                    return true
                }
                else if emailtextfeild.hasText && passwordtextfeild.hasText == false {
                    passwordtextfeild.becomeFirstResponder()
                    return true
                    
                }
                else{
                    emailtextfeild.attributedPlaceholder = NSAttributedString(string: "ENTER YOUR EMAIL",
                                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.yellow])
                    passwordtextfeild.attributedPlaceholder = NSAttributedString(string: "ENTER YOUR PASSWORD",
                                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.yellow])
                    return false
                }
                
            }
            else if k == false {
                emailtextfeild.text = ""
                emailtextfeild.attributedPlaceholder = NSAttributedString(string: "PLACE A VALID EMAIL",
                                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
                return false
                
            }
        }
        emailtextfeild.attributedPlaceholder = NSAttributedString(string: "EMAIL???????",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        
        return false
            
        
    }
  
    
    
}



//MARK: - appleSignIn extensions

extension secondViewController : ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential{
            guard let nonce = currentNonce else {
                print("fatal error")
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("unable to fetch id token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize string")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString , rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authDataResult, error) in
                if let user = authDataResult?.user {
                    print("nice \(user)")
                }
            }
        }
    }
    
}

extension secondViewController : ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
}







    

    
    



