//
//  InitialViewController.swift
//  AppPrototype
//
//  Created by Lika, Jason on 17/04/2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var segueFromController = "MainViewController"
    
    // Check for core data
    // App logo symbol for a second (instagram, twitter, etc)
    // Show slideshow of UIIMages(?) OR segue to map based on core data
    
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBAction func getStartedButton(_ sender: Any) {
        if segueFromController == "MainViewController" {
            self.performSegue(withIdentifier: "welcomeToMain", sender: nil)
        } else if segueFromController == "MapViewController" {
            self.performSegue(withIdentifier: "unwindToMap", sender: nil)
        } else if segueFromController == "JournalViewController" {
            self.performSegue(withIdentifier: "unwindToJournal", sender: nil)
        } else if segueFromController == "PlanViewController" {
            self.performSegue(withIdentifier: "unwindToPlan", sender: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if segueFromController == "MainViewController" {
            getStartedButton.titleLabel?.text = "Get Started"
        } else if segueFromController == "MapViewController" {
            getStartedButton.titleLabel?.text = "Back to Map"
        } else if segueFromController == "JournalViewController" {
            getStartedButton.titleLabel?.text = "Back to Journal"
        } else if segueFromController == "PlanViewController" {
            getStartedButton.titleLabel?.text = "Back to Plan"
        }

        // Do any additional setup after loading the view.
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
