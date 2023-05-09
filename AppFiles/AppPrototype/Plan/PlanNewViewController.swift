//
//  PlanNewViewController.swift
//  AppPrototype
//
//  Created by Cuello-Wolffe, Benjamin on 10/03/2023.
//

import UIKit

class PlanNewViewController: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate {
    
    //Variables
    var selectedPlan = ["ID" : Int(), "city" : String(), "startDate" : Date(), "endDate" : Date(), "transportToType" : String(), "transportToDateTime" : Date(), "transportFromType" : String(), "transportFromDateTime" : Date(), "activitesTextEntry" : String()] as [String : Any]
    var isNewPlan = false
    var accomodationList = ["Accom1", "Accom2", "Accom3"]
    var segueFromController = String()
    
    //IBOutlets
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var CitySearchBar: UISearchBar!
    
    @IBOutlet weak var TransportToSearchBar: UISearchBar!
    
    @IBOutlet weak var TransportFromSearchBar: UISearchBar!
    
    @IBOutlet weak var accomPicker: UIPickerView!
    
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    
    @IBOutlet weak var EndDatePicker: UIDatePicker!
    
    @IBOutlet weak var TransportToDatePicker: UIDatePicker!
    
    @IBOutlet weak var TransportFromDatePicker: UIDatePicker!
    
    @IBOutlet weak var CheckInDatePicker: UIDatePicker!
    
    @IBOutlet weak var CheckOutDatePicker: UIDatePicker!
    
    @IBOutlet weak var ActivityTextField: UITextView!
    
    
    @IBAction func backAndSave(_ sender: Any) {
        
        if segueFromController == "PlanViewController" {
            performSegue(withIdentifier: "unwindToPlan", sender: nil)
        } else if segueFromController == "PlanDetailViewController" {
            performSegue(withIdentifier: "unwindToPlanDetail", sender: nil)
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        accomPicker.delegate = self
        accomPicker.dataSource = self
        navigationBar.delegate = self
        
        CitySearchBar.text = selectedPlan["city"] as? String
        TransportToSearchBar.text = selectedPlan["transportToType"] as? String
        TransportFromSearchBar.text = selectedPlan["transportFromType"] as? String
        // Set accom picker
        StartDatePicker.date = selectedPlan["startDate"] as! Date
        EndDatePicker.date = selectedPlan["endDate"] as! Date
        TransportToDatePicker.date = selectedPlan["transportToDateTime"] as! Date
        TransportFromDatePicker.date = selectedPlan["transportFromDateTime"] as! Date
//        CheckInDatePicker.date
//        CheckOutDatePicker.date
        ActivityTextField.text = selectedPlan["activityTextEntry"] as? String
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedPlan["city"] = CitySearchBar.text
        selectedPlan["startDate"] = StartDatePicker.date
        selectedPlan["endDate"] = EndDatePicker.date
        selectedPlan["transportToType"] = TransportToSearchBar.text
        selectedPlan["transportToDateTime"] = TransportToDatePicker.date
        // Add time functionality
        selectedPlan["transportFromType"] = TransportFromSearchBar.text
        selectedPlan["transportFromDateTime"] = TransportFromDatePicker.date
        selectedPlan["activitiesTextEntry"] = ActivityTextField.text
        // Add time functionality
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

extension PlanNewViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return accomodationList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return accomodationList[row]
    }
}

