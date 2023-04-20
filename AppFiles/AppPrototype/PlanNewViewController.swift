//
//  PlanNewViewController.swift
//  AppPrototype
//
//  Created by Cuello-Wolffe, Benjamin on 10/03/2023.
//

import UIKit

class PlanNewViewController: UIViewController {
    
    //Variables
    var selectedPlan = ["ID" : Int(), "city" : String(), "startDate" : Date(), "endDate" : Date(), "transportToType" : String(), "transportToDateTime" : Date(), "transportFromType" : String(), "transportFromDateTime" : Date(), "activitesTextEntry" : String()] as [String : Any]
    var isNewPlan = false
    var accomodationList = ["Accom1", "Accom2", "Accom3"]
    
    //IBOutlets
    
    
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
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        accomPicker.delegate = self
        accomPicker.dataSource = self
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

