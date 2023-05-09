//
//  SplashViewController.swift
//  AppPrototype
//
//  Created by Cuello-Wolffe, Benjamin on 27/04/2023.
//

import UIKit

class SplashViewController: UIViewController {
    
    
    
    var hasLaunched = false
    var segueCont = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Get a reference to UserDefaults
        let defaults = UserDefaults.standard

        // Check if the "hasLaunchedBefore" key exists in UserDefaults
        if defaults.bool(forKey: "hasLaunchedBefore") {
            hasLaunched = true
            segueCont = "splashToLogin"
            //performSegue(withIdentifier: "splashToLogin", sender: nil)
        } else {
            // App is running for the first time
            //defaults.set(true, forKey: "hasLaunchedBefore")
            segueCont = "splashToWelcome"
            //performSegue(withIdentifier: "welcome", sender: nil) change this to whatever the id is for the segue
        }
        print(hasLaunched)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func test(_ sender: Any) {
        performSegue(withIdentifier: segueCont, sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "splashToLogin" {
            let LoginViewController = segue.destination as! LoginViewController
            LoginViewController.hasLaunched = hasLaunched

        }
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
