//
//  PlanNewViewController.swift
//  AppPrototype
//
//  Created by Cuello-Wolffe, Benjamin on 10/03/2023.
//

import UIKit

//Testing if commit works

class PlanNewViewController: UIViewController {
    
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    
    @IBOutlet weak var EndDatePicker: UIDatePicker!
    
    @IBOutlet weak var TransportToDatePicker: UIDatePicker!
    
    @IBOutlet weak var TransportFromDatePicker: UIDatePicker!
    
    @IBOutlet weak var CheckInDatePicker: UIDatePicker!
    
    @IBOutlet weak var CheckOutDatePicker: UIView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
