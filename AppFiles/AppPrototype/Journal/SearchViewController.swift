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

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Location Search"
//        navigationController?.navigationBar
        
        view.addSubview(mapView)
        searchVC.searchBar.backgroundColor = .systemGray2
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
        performSegue(withIdentifier: "unwindToJournalEntry", sender: nil)
    }
    
//    func position(for bar: UIBarPositioning) -> UIBarPosition {
//        return .topAttached
//    }


}


extension SearchViewController: ResultsViewControllerDelegate {
    func didTapPlace(coordinates: CLLocationCoordinate2D, place: Place) {
        searchVC.resignFirstResponder()
        searchVC.dismiss(animated: true, completion: nil)
        
        searchVC.searchBar.text = place.name
        
        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector (GoBack)), animated: false)
        
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
