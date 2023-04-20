//
//  PlanDetailViewController.swift
//  AppPrototype
//
//  Created by Cuello-Wolffe, Benjamin on 10/03/2023.
//

import UIKit

class PlanDetailViewController: UIViewController {
    
    var selectedPlan = ["ID" : Int(), "city" : String(), "startDate" : Date(), "endDate" : Date(), "transportToType" : String(), "transportToDateTime" : Date(), "transportFromType" : String(), "transportFromDateTime" : Date(), "activitesTextEntry" : String()] as [String : Any]
    
    
    @IBOutlet weak var CityLabel: UILabel!
    
    @IBOutlet weak var StartDateLabel: UILabel!
    
    @IBOutlet weak var EndDateLabel: UILabel!
    
    @IBOutlet weak var TransportToTypeLabel: UILabel!
    
    @IBOutlet weak var TransportToDateLabel: UILabel!
    
    @IBOutlet weak var TransportToTimeLabel: UILabel!
    
    
    @IBOutlet weak var TransportFromTypeLabel: UILabel!
    
    
    @IBOutlet weak var TransportFromDateLabel: UILabel!
    
    @IBOutlet weak var TransportFromTimeLabel: UILabel!
    
    @IBOutlet weak var ActivitiesTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//    
//    @IBAction func unwindToPlan(_ unwindSegue: UIStoryboardSegue) {
//        _ = unwindSegue.source
//        
//        performSegue(withIdentifier: "toPlan", sender: nil)
//        // Use data from the view controller which initiated the unwind segue
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
