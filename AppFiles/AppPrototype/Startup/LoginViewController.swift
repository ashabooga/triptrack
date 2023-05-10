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
    var passcode = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPasscode()
    }
    
    @IBOutlet weak var FaceIDButton: UIButton!
    
    @IBOutlet weak var PasscodeFieldText: UITextField!
    
    @IBAction func LoginPasscodeButton(_ sender: Any) {
        if PasscodeFieldText.text == passcode {
            LoggedIn()
        } else {
            let alert = UIAlertController(title: "Incorrect passcode.", message: "Please try again or click 'Forgot Passcode'.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    @IBAction func ResetPasscodeButton(_ sender: Any) {
        performSegue(withIdentifier: "loginToReset", sender: nil)
    }
    
    
    
    func LoggedIn() {
        performSegue(withIdentifier: "loginToMain", sender: nil)
    }
    
    
    @IBAction func FaceIDButton(_ sender: Any) {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] success, error in
                DispatchQueue.main.async {
                    guard success, error ==  nil else {
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
    
    func getPasscode() {
        do {
            let data = (try KeychainManager.get(service: "Trip Track", account: "localUser"))!
            let keychainPasscode = String(decoding: data, as: UTF8.self)
                        
            passcode = keychainPasscode
        } catch {
            print("Failed to read passcode")
        }
    }

}

class KeychainManager {
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
        case noPasscode
    }
    
    static func save(service: String, account: String, password: Data) throws {
        let query: [String: AnyObject] = [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service as AnyObject, kSecAttrAccount as String: account as AnyObject, kSecValueData as String: password as AnyObject]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        print("saved keychain")
    }
    
    static func get(service: String, account: String) throws -> Data? {
        let query: [String: AnyObject] = [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service as AnyObject, kSecAttrAccount as String: account as AnyObject, kSecReturnData as String: kCFBooleanTrue, kSecMatchLimit as String: kSecMatchLimitOne]
        
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print(status)
        
        return result as? Data
    }
    
    static func update(service: String, account: String, password: Data) throws {
            
        let query: [String: AnyObject] = [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service as AnyObject]
        
        let attributes: [String: AnyObject] = [kSecAttrAccount as String: account as AnyObject, kSecValueData as String: password as AnyObject]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.noPasscode
            
        }
        guard status == errSecSuccess else { throw KeychainError.unknown(status)
        }
        print("Updated")
    }
}
