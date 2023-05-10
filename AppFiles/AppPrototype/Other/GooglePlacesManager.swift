//
//  GooglePlacesManager.swift
//  AppPrototype
//
//  Created by Ben Cuello-Wolffe on 5/6/23.
//

import Foundation
import GooglePlaces

struct Place {
    let name: String
    let id: String
}

enum placesError: Error {
    case failedToFind
    case failedToGetCoordinates
}

final class GooglePlacesManager {
    static let shared = GooglePlacesManager()
    
    private let client = GMSPlacesClient.shared()
    
    private init() {}
    
//    public func setUp() {
//        GMSPlacesClient.provideAPIKey("AIzaSyBl_h5AvRJZWOGF9EgmHGYppZoGOec89po")
//    }
    
    public func findPlaces(query: String, completion: @escaping (Result<[Place], Error>) -> Void) {
        
        let filter = GMSAutocompleteFilter()
        
        
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil, callback: { (results, error) in
            if error != nil {
                completion(.failure(placesError.failedToFind))
                return
            }
            if let results = results {
                let places: [Place] = results.compactMap({Place(name: $0.attributedFullText.string, id: $0.placeID)
                    
                })
                
                completion(.success(places))
            }
        })
        
    }
    
    public func resolveLocation(for place: Place, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        client.fetchPlace(fromPlaceID: place.id, placeFields: .coordinate, sessionToken: nil) { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(placesError.failedToGetCoordinates))
                return
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: googlePlace.coordinate.latitude, longitude: googlePlace.coordinate.longitude)
            
            completion(.success(coordinate))
        }
        
    }
}
