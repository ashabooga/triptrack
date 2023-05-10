//
//  PlanNewViewController.swift
//  AppPrototype
//
//  Created by Cuello-Wolffe, Benjamin on 10/03/2023.
//

import UIKit
import CoreLocation

class PlanNewViewController: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate {
    
    //Variables
    var selectedPlan = ["ID" : Int(), "city" : String(), "startDate" : Date(), "endDate" : Date(), "transportToType" : String(), "transportToDateTime" : Date(), "transportFromType" : String(), "transportFromDateTime" : Date(), "activitesTextEntry" : String()] as [String : Any]
    var isNewPlan = false
    var accomodationList = ["Accom1", "Accom2", "Accom3"]
    var segueFromController = String()
    var selectedLocation = CLLocationCoordinate2D()
    var selectedPlace = Place(name: "", id: "")
    var whichButton = ""
    var cityPlace = Place(name: "", id: "")
    var transportToPlace = Place(name: "", id: "")
    var transportFromPlace = Place(name: "", id: "")
    
    //IBOutlets
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var citySearchButton: UIButton!
    
    @IBOutlet weak var transportToButton: UIButton!
    
    @IBOutlet weak var transportFromButton: UIButton!
    
    @IBOutlet weak var accomPicker: UIPickerView!
    
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    
    @IBOutlet weak var EndDatePicker: UIDatePicker!
    
    @IBOutlet weak var TransportToDatePicker: UIDatePicker!
    
    @IBOutlet weak var TransportFromDatePicker: UIDatePicker!
    
    @IBOutlet weak var CheckInDatePicker: UIDatePicker!
    
    @IBOutlet weak var CheckOutDatePicker: UIDatePicker!
    
    @IBOutlet weak var ActivityTextField: UITextView!
    
    
    @IBAction func backAndSave(_ sender: Any) {
        var errorMessage = ""

        if (citySearchButton.titleLabel?.text == " Location Search" || transportToButton.titleLabel?.text == " Location Search" || transportFromButton.titleLabel?.text == " Location Search") {
            if errorMessage != "" {
                errorMessage = "Please fill title and location fields OR delete entry."
            } else {
                errorMessage = "Please fill location field OR delete entry."
            }
        }
        
        let alert = UIAlertController(title: "Fields Left Empty", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue Editing", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete Entry", style: .destructive, handler: { [self] (action: UIAlertAction!) in
            if self.segueFromController == "PlanViewController" {
                performSegue(withIdentifier: "unwindToPlan", sender: nil)
            } else if segueFromController == "PlanDetailViewController" {
                performSegue(withIdentifier: "unwindToPlanDetail", sender: nil)
            }
        }))
        if errorMessage != "" {
            present(alert, animated: true)
            
        }
        else {
            if self.segueFromController == "PlanViewController" {
                performSegue(withIdentifier: "unwindToPlan", sender: nil)
            } else if segueFromController == "PlanDetailViewController" {
                performSegue(withIdentifier: "unwindToPlanDetail", sender: nil)
            }
        }
    }
    
    
    
    @IBAction func cityButton(_ sender: Any) {
        whichButton = "cityButton"
        performSegue(withIdentifier: "planToSearch", sender: nil)
        
    }
    
    
    @IBAction func transportToSearchButton(_ sender: Any) {
        whichButton = "transportToSearchButton"
        performSegue(withIdentifier: "planToSearch", sender: nil)
    }
    
    
    @IBAction func transportFromSearchButton(_ sender: Any) {
        whichButton = "transportFromSearchButton"
        performSegue(withIdentifier: "planToSearch", sender: nil)
    }

    
    
    @IBAction func unwindToPlanEntry(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.source is SearchViewController {
            let SearchViewController = unwindSegue.source as! SearchViewController
            self.selectedPlace = SearchViewController.selectedPlace
            self.selectedLocation = SearchViewController.selectedLocation
            self.whichButton = SearchViewController.whichButton
            if whichButton == "cityButton" {
                citySearchButton.setTitle(" " + selectedPlace.name, for: UIControl.State.normal)
                cityPlace = selectedPlace
                
            }
            else if whichButton == "transportToSearchButton" {
                transportToButton.setTitle(" " + selectedPlace.name, for: .normal)
                transportToPlace = selectedPlace
            }
            else if whichButton == "transportFromSearchButton" {
                transportFromButton.setTitle(" " + selectedPlace.name, for: .normal)
                transportFromPlace = selectedPlace
            }
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

        selectedPlan["city"] = cityPlace.name
        selectedPlan["startDate"] = StartDatePicker.date
        selectedPlan["endDate"] = EndDatePicker.date
        selectedPlan["transportToType"] = transportToPlace.name
        selectedPlan["transportToDateTime"] = TransportToDatePicker.date
        // Add time functionality
        selectedPlan["transportFromType"] = transportFromPlace.name
        selectedPlan["transportFromDateTime"] = TransportFromDatePicker.date
        selectedPlan["activitiesTextEntry"] = ActivityTextField.text
        if segue.identifier == "planToSearch" {
            let NavigationController = segue.destination as! UINavigationController
            let SearchViewController = NavigationController.topViewController as! SearchViewController
            SearchViewController.whichButton = whichButton
            SearchViewController.segueFromController = "PlanEntryViewController"
            // Add time functionality
            
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

