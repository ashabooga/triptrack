//
//  SearchViewController.swift
//  AppPrototype
//
//  Created by Cuello-Wolffe, Benjamin on 05/05/2023.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, UISearchResultsUpdating {

    let mapView = MKMapView()
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    var selectedPlace = Place(name: "", id: "")
    var selectedLocation = CLLocationCoordinate2D()
    var segueFromController = ""
    var whichButton = ""
    var isCitySearch = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if whichButton == "cityButton" {
            isCitySearch = true
        }
        else{
            isCitySearch = false
        }
        view.addSubview(mapView)
        searchVC.searchBar.backgroundColor = .white
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchVC.becomeFirstResponder()
        
        if selectedPlace.name != "" {
            didTapPlace(coordinates: selectedLocation, place: selectedPlace)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchVC.searchBar.text, !query.trimmingCharacters (in: .whitespaces) .isEmpty, let resultsVC = searchController.searchResultsController as? ResultsViewController else {
            return
        }
        
        resultsVC.delegate = self
        
        GooglePlacesManager.shared.findPlaces(query: query) { result in switch result {
            case.success(let places):
                DispatchQueue.main.async {
                    resultsVC.update(with: places)
                }
            case.failure(let error):
                print(error)
            }
        }
    }

    
    @objc func GoBack() {
        if isCitySearch {
            GeocodeAddress(requests: ["city", "country"], latitude: selectedLocation.latitude, longitude: selectedLocation.longitude) { result in
                self.selectedPlace = Place(name: result[0] + ", " + result[1], id: self.selectedPlace.id)
                if self.segueFromController == "PlanEntryViewController" {
                    self.performSegue(withIdentifier: "unwindToPlanEntry", sender: nil)
                }
            }
        } else {
            if self.segueFromController == "JournalEntryViewController" {
                self.performSegue(withIdentifier: "unwindToJournalEntry", sender: nil)
                
            } else if self.segueFromController == "PlanEntryViewController" {
                self.performSegue(withIdentifier: "unwindToPlanEntry", sender: nil)
            }
        }
    }
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
    }
    
    func GeocodeAddress(requests: [String], latitude: Double, longitude: Double, completion: @escaping ([String]) -> Void) {
        geocode(latitude: latitude, longitude: longitude) { placemark, error in
            guard let placemark = placemark, error == nil else {
                completion([]) // Call completion with empty string if there was an error
                return
            }
            
            let country = placemark.country ?? "N/A"
            let addressName = placemark.thoroughfare ?? "N/A"
            let city = placemark.locality ?? "N/A"
            
            var output: [String] = []
            
            if requests.count == 1 {
                if requests[0] == "city" {
                    output.append(city)
                } else if requests[0] == "country" {
                    output.append(country)
                } else if requests[0] == "addressName" {
                    output.append(addressName)
                }
            } else {
                for request in requests {
                    if request == "city" {
                        output.append(city)
                    } else if request == "country" {
                        output.append(country)
                    } else if request == "addressName" {
                        output.append(addressName)
                    }
                }
            }
            
            completion(output)
            
        }
    }


}


extension SearchViewController: ResultsViewControllerDelegate {
    func didTapPlace(coordinates: CLLocationCoordinate2D, place: Place) {
        searchVC.resignFirstResponder()
        searchVC.dismiss(animated: true, completion: nil)
        
        searchVC.searchBar.text = place.name
        
        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector (GoBack)), animated: false)
        print(segueFromController)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025)), animated: true)
        
        selectedLocation = coordinates
        selectedPlace = place
        
    }
}
