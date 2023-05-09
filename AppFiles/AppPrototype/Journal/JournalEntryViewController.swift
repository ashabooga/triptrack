//
//  JournalEntryViewController.swift
//  AppPrototype
//
//  Created by Witkowska, Natalia on 13/03/2023.
//

import UIKit
import PhotosUI
import MapKit

class MyPlacemark: CLPlacemark {}

class JournalEntryViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate, UIScrollViewDelegate, UINavigationBarDelegate, UIBarPositioningDelegate {
    
    

    var selectedEntry = ["ID" : Int(), "title" : String(), "location" : String(), "latitude" : Double(), "longitude" : Double(), "date" : Date(), "textEntry" : String(), "photos" : [UIImage](), "photoIDs" : [String]()] as [String : Any]
    var isNewEntry = false
    

    var imagePicker = UIImagePickerController()
    var selectedCountry: String?
    var countryList = ["Algeria", "Andorra", "Angola", "India", "Thailand"]
    var currentDate = Date()
    var imageList = [UIImage]()
    var page = UIPageControl()
    var isCreated = false
    var scroll = UIScrollView()
    var segueFromController : String!
    var selectedPlace = Place(name: "", id: "")
    var selectedLocation = CLLocationCoordinate2D()
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backOutlet: UIButton!
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var thoughtTextView: UITextView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    
    @IBOutlet weak var LocationSearchButton: UIButton!
    @IBAction func LocationSearchButton(_ sender: Any) {
        performSegue(withIdentifier: "entryToSearch", sender: nil)
    }
    
    
    
    @IBAction func backAndSave(_ sender: Any) {
        selectedEntry["title"] = titleText.text
//        selectedEntry["location"] = "LOCATION"
        selectedEntry["date"] = datePicker.date
        selectedEntry["textEntry"] = thoughtTextView.text
        selectedEntry["photos"] = imageList
        selectedEntry["location"] = selectedPlace.name
        selectedEntry["latitude"] = selectedLocation.latitude
        selectedEntry["longitude"] = selectedLocation.longitude
        if segueFromController == "JournalViewController"{
            self.performSegue(withIdentifier: "unwindToJournal", sender: nil)
        }
        else if segueFromController == "MapViewController"{
            self.performSegue(withIdentifier: "unwindToMap", sender: nil)
         }
        else if segueFromController == "JournalDetailViewController"{
            self.performSegue(withIdentifier: "unwindToDetail", sender: nil)
        }
    }

    
    
    @IBAction func addPhotoButton(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 5
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
        
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.present(UINavigationController(rootViewController: SearchViewController()), animated: false, completion: nil)
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int((scrollView.contentOffset.x / pageWidth).rounded())
        // Update the current page of the page control
        page.currentPage = currentPage
    }
    
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        
        let dispatchGroup = DispatchGroup()  // Create a new dispatch group
        
        for result in results {
            dispatchGroup.enter()  // Notify the group that a task will be added
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self, let image = image as? UIImage else {
                    dispatchGroup.leave()  // Notify the group that the task is done
                    return
                }
                
                
                //for i in 0..<self.imageList.count {
                    //for j in i+1..<self.imageList.count {
                        //if self.imageList[i] != self.imageList[j] {
                            self.imageList.append(image)
                        //}
                    //}
                //}
                
                
                dispatchGroup.leave()  // Notify the group that the task is done
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {  // Called after all tasks are done
            self.buttonFinished()
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let JournalViewController = segue.destination as? JournalViewController {
            JournalViewController.selectedEntry = self.selectedEntry
            
        }
        if let JournalDetailViewController = segue.destination as? JournalDetailViewController {
            JournalDetailViewController.selectedEntry = self.selectedEntry
            
        }
        
        if segue.identifier == "entryToSearch" {
            let NavigationController = segue.destination as! UINavigationController
            let SearchViewController = NavigationController.topViewController as! SearchViewController
            
            SearchViewController.selectedPlace = self.selectedPlace
            SearchViewController.selectedLocation = self.selectedLocation
        }
    }
    
    
    
    func buttonFinished() {
        // Create a UIScrollView

        let scrollView = UIScrollView(frame: CGRect(x: 50, y: 600, width: 300, height: 205))
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: scrollView.frame.maxY - 50, width: view.frame.width, height: 50))
            
        scrollView.backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
            
            
        pageControl.numberOfPages = imageList.count
        pageControl.currentPage = 0
        //pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
        page = pageControl
        scroll = scrollView
        view.addSubview(scrollView)
        view.addSubview(pageControl)
            
            // Add UIImageViews to the UIScrollView based on the imageList array
        for index in 0..<self.imageList.count {
            let imageView = UIImageView(frame: CGRect(x: scrollView.frame.width * CGFloat(index), y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
                //imageView.contentMode = .scaleAspectFit
            
            imageView.image = self.imageList[index]
            scrollView.addSubview(imageView)
        }
            
            // Set the content size of the UIScrollView based on the number of images
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(imageList.count), height: scrollView.frame.height)
            
        scrollView.delegate = self
        scrollView.bringSubviewToFront(pageControl)
            
        photoButton.frame.origin = CGPoint(x: 230, y: 570)
        photoButton.frame.size = CGSize(width: 120, height: 20)
        photoButton.titleLabel?.font = UIFont.init(name: "System", size: 10)
        
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    @IBAction func unwindToJournalEntry(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.source is SearchViewController {
            let SearchViewController = unwindSegue.source as! SearchViewController
            
            self.selectedPlace = SearchViewController.selectedPlace
            self.selectedLocation = SearchViewController.selectedLocation
            
            LocationSearchButton.setTitle(" " + selectedPlace.name, for: UIControl.State.normal)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.delegate = self
        datePicker.maximumDate = currentDate
        currentLocation = locManager.location
        
//        selectedEntry["latitude"] = currentLocation.coordinate.latitude
//        selectedEntry["longitude"] = currentLocation.coordinate.longitude
        
        if segueFromController == "JournalDetailViewController" {
            backOutlet.setTitle(" Entry", for: .normal)
            navigationTitle.title = "EDIT ENTRY"
            thoughtTextView.text = (selectedEntry["textEntry"] as! String)
            LocationSearchButton.setTitle((selectedEntry["location"] as! String), for: UIControl.State.normal)
            titleText.text = (selectedEntry["title"] as! String)
            //country.text = (selectedEntry["country"] as! String)
            datePicker.date = (selectedEntry["date"] as! Date)
            if selectedEntry["photos"] != nil {
                imageList = (selectedEntry["photos"] as! [UIImage])
                buttonFinished()
            }
            
            
        }
        else {
            navigationTitle.title = "NEW ENTRY"
            if segueFromController == "MapViewController" {
                backOutlet.setTitle(" Map", for: .normal)
            }
        }
        
    }
}