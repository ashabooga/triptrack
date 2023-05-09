//
//  LoginResetViewController.swift
//  AppPrototype
//
//  Created by Ben Cuello-Wolffe on 5/8/23.
//

import UIKit
import LocalAuthentication

class LoginResetViewController: UIViewController {

    let context = LAContext()
    var error: NSError? = nil
    let reason = "Please authenticate to proceed."
    var appHasBeenOpened = false
    
    @IBOutlet weak var PasscodeFieldOne: UITextField!
    @IBOutlet weak var PasscodeFieldTwo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setLeftBarButton(UIBarButtonItem (barButtonSystemItem: .cancel, target: self, action: #selector (UnwindReset)), animated: false)
    }
    
    @objc func UnwindReset() {
        performSegue(withIdentifier: "unwindToLogin", sender: nil)
    }
    
    func SegueForwards() {
        if appHasBeenOpened {
            performSegue(withIdentifier: "loginResetToMain", sender: nil)
        } else {
            performSegue(withIdentifier: "loginResetToWelcome", sender: nil)
        }
    }
    
    
    
    @IBAction func ResetPasscodeButton(_ sender: Any) {
        
        if PasscodeFieldOne.text == "" || PasscodeFieldTwo.text == "" {
            let alert = UIAlertController(title: "Passcodes cannot be blank.", message: "Please enter a valid passcode.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
        } else if PasscodeFieldOne.text == PasscodeFieldTwo.text { // Passcodes Match
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] success, error in
                    DispatchQueue.main.async {
                        guard success, error ==  nil else {
                            return
                        }
                        
                        // Success
                        self!.SegueForwards()
                    }
                }
            } else { // Could not use biometrics
                let alert = UIAlertController(title: "Unavailable", message: "You can't use this feature.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                present(alert, animated: true)
            }
            
        } else { // Passcodes don't match
            let alert = UIAlertController(title: "Passcodes don't match.", message: "Please re-enter matching passcodes.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
        }
    }
}
