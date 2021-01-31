//
//  applesigninViewController.swift
//  NOBIS2020
//
//  Created by Henit Work on 13/01/21.
//

import UIKit
import CryptoKit
import AuthenticationServices
import Firebase
import FirebaseAuth

class applesigninViewController: UIViewController{
    var currentNonce: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
//            self.setupsigninbutton()
        }
        
        
        
            }
    
    
//    func setupsigninbutton(){
//            let button = ASAuthorizationAppleIDButton()
//            button.addTarget(self, action: #selector(handleSignInWithAppleTapped), for: .touchUpInside)
//            button.center = view.center
//            view.addSubview(button)
//        // Do any additional setup after loading the view.
//    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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

extension applesigninViewController : ASAuthorizationControllerDelegate{
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

extension applesigninViewController : ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
}

