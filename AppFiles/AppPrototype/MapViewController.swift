import CoreLocation
import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var userLocation = CLLocation()
    var locationManager = CLLocationManager()
    var firstRun = true
    var startTrackingTheUser = false

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //this method returns an array of locations
        let locationOfUser = locations[0]
        
        //gather latitiude and longitude values of user
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        //get the users location (latitude & longitude)
        userLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        if firstRun {
            firstRun = false
                
            //set CLLocationDegrees for latitide and longitude
            let latDelta: CLLocationDegrees = 0.0025
            let lonDelta: CLLocationDegrees = 0.0025
                
            //setting a span defining how large area is depicted on the map
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
                 
            //setting region defining centre and size of area covered
            let region = MKCoordinateRegion(center: location, span: span)
                 
            //make the map show that region just defined
            self.mapView.setRegion(region, animated: true)
                
            //setup a timer to set boolean to true in 5 seconds
            _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(startUserTracking), userInfo: nil, repeats: false)
        }
        
        //set center if user has started being tracked
        if startTrackingTheUser == true {
            mapView.setCenter(location, animated: true)
        }
    }
    
    //set the startTrackingTheUser boolean class property to true
    @objc func startUserTracking() {
        startTrackingTheUser = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make this view controller a delegate of the Location Manager, so that it is able to call functions provided in this view controller
        locationManager.delegate = self as CLLocationManagerDelegate
                 
        //set the level of accuracy for the user's location.
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                 
        //ask the location manager to request authorisation from the user
        locationManager.requestWhenInUseAuthorization()
                 
        //once the user's location is being provided then ask for updates when the user moves around
        locationManager.startUpdatingLocation()
                 
        //configure the map to show the user's location (with a blue dot)
        mapView.showsUserLocation = true
    }
}
