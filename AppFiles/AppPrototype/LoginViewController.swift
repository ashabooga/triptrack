//
//  LoginViewController.swift
//  AppPrototype
//
//  Created by Cuello-Wolffe, Benjamin on 27/04/2023.
//

import LocalAuthentication
import UIKit

class LoginViewController: UIViewController {
    
    let context = LAContext()
    var error: NSError? = nil
    let reason = "Please authenticate to proceed."
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var FaceIDButton: UIButton!
    @IBOutlet weak var PasscodeButton: UIButton!
    
    
    func LoggedIn() {
        performSegue(withIdentifier: "loginToWelcome", sender: nil)
    }
    
    
    @IBAction func FaceIDButton(_ sender: Any) {
        
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] success, error in
                DispatchQueue.main.async {
                    guard success, error ==  nil else {
                        // Failed
//                        let alert = UIAlertController(title: "Failed to Authenticate", message: "Please try again or use your password.", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
//                        self!.present(alert, animated: true)
                        
                        return
                    }
                    
                    // Success
                    self!.LoggedIn()
                }
            }
        } else { // Could not use biometrics
            let alert = UIAlertController(title: "Unavailable", message: "You can't use this feature", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    @IBAction func PasscodeButton(_ sender: Any) {
        
        
        
        
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
