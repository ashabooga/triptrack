import CoreLocation
import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    var titleList = [String]()
    var locationList = [String]()
    var dateList = [Date]()
    var textEntryList = [String]()
    var photosList = [[UIImage]]()
    var photoIDsList = [[String]]()
    var latitudeList = [Double]()
    var longitudeList = [Double]()
//    var latitudeList = [51.509742561831395, 51.51039252938496, 51.510793117046255]
//    var longitudeList = [-0.1335390878740101, -0.1339823955994906, -0.13284215692778817]
    var annotationList = [MKPointAnnotation]()
    var indexPat = Int()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var selectedEntry = ["ID" : Int(), "title" : String(), "location" : String(), "latitude" : Double(), "longitude" : Double(), "date" : Date(), "textEntry" : String(), "photos" : [UIImage](), "photoIDs" : [String]()] as [String : Any]
    
    @IBOutlet weak var mapView: MKMapView!
    
    //    selectedEntry["ID"] = 6
    //    selectedEntry["latidute"] = latitudeList[6]
    
    var userLocation = CLLocation()
    var locationManager = CLLocationManager()
    var firstRun = true
    var startTrackingTheUser = false
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "toNew" {
    //            let JournalEntryViewController = segue.destination as! JournalEntryViewController
    //            JournalEntryViewController.segueFromController = "MapViewController"
    //        }
    //    }
    
    
    
    //Unwind segue called when back button pressed in second view controller
    @IBAction func unwindToMap(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    
    
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
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "mapToNewJournal", sender: nil)
        

    }
    
    func action(gestureRecognizer:UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        mapView.addAnnotation(annotation)

    }
    
    @objc func handleLongTapGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            let touchArea = gestureRecognizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchArea, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            
            annotation.title = "Latitude: \(locationCoordinate.latitude), Longitude: \(locationCoordinate.longitude)"
            
            mapView.addAnnotation(annotation)
            print(locationCoordinate.latitude)
            print(locationCoordinate.longitude)
            
        }
        
        
        if gestureRecognizer.state != UIGestureRecognizer.State.began {
            performSegue(withIdentifier: "mapToNewJournal", sender: nil)
            
            return
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotation) {
        print("test1")
        
        //initalise index
        var index = 0
        
        //loop over annotations and check if view matches specific annotation to perform the segue when an annotaion is pressed
        for _ in latitudeList {
            if (view.coordinate.latitude == latitudeList[index]) {
                if (view.coordinate.longitude == longitudeList[index]) {
                    
                }
                indexPat = index
                performSegue(withIdentifier: "mapToDetailJournal", sender: nil)
                print("test")
            }
            else {
                index += 1
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapToDetailJournal" {
            
            let JournalDetailViewController = segue.destination as! JournalDetailViewController
            
            selectedEntry["ID"] = indexPat
            selectedEntry["title"] = titleList
            selectedEntry["location"] = locationList
            selectedEntry["latitude"] = latitudeList
            selectedEntry["longitude"] = longitudeList
            selectedEntry["date"] = dateList
            selectedEntry["textEntry"] = textEntryList
            selectedEntry["photos"] = photosList
            selectedEntry["photoIDs"] = photoIDsList
            
            JournalDetailViewController.selectedEntry = self.selectedEntry
        }
        else {
            let JournalEntryViewController = segue.destination as! JournalEntryViewController
            JournalEntryViewController.segueFromController = "MapViewController"
            
        }
        
    }
    
    func fetchCoreData() {
        
        do {
            let managedJournal = try context.fetch(Journal.fetchRequest())
            
            for entry in managedJournal {
                
                titleList.append(entry.titles!)
                locationList.append(entry.locationNames!)
                dateList.append(entry.dates!)
                textEntryList.append(entry.textEntries!)
                photosList.append([UIImage(named: "noImage")!])
                latitudeList.append(entry.latitudes)
                longitudeList.append(entry.longitudes)
                
//                photosList.append(entry.photoLists!)
                
            }
            
        } catch {
            print("Couldn't fetch core data")
        }
    }
    
    func saveCoreData() {
        do {
            try self.context.save()
        } catch {
            print("couldn't save core data")
        }
    }
    
    func insertToCoreData() {
        let coreDataResults = try! self.context.fetch(Journal.fetchRequest())
        
        for coreDataResult in coreDataResults {
            self.context.delete(coreDataResult)
            saveCoreData()
        }
        
        if titleList.count > 0 {
            
            for i in 0...titleList.count-1 {
                let newEntry = Journal(context: self.context)
                
                newEntry.titles = titleList[i]
                newEntry.locationNames = locationList[i]
                newEntry.latitudes = latitudeList[i]
                newEntry.longitudes = longitudeList[i]
                newEntry.dates = dateList[i]
                newEntry.textEntries = textEntryList[i]
                
                //            newEntry.photoLists = photosList[i]
                //            newEntry.photoIDLists = photoIDsList[i]
                saveCoreData()
                
            }
        
            
        
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("disapperaing map")
        
        insertToCoreData()
        print(titleList.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("appearing map")
        
        fetchCoreData()
        print(titleList.count)
        
        for i in 0..<latitudeList.count {
            let coordinate = CLLocationCoordinate2D(latitude: latitudeList[i], longitude: longitudeList[i])
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let oLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongTapGesture(gestureRecognizer:)))
        self.mapView.addGestureRecognizer(oLongTapGesture)
        
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
        /*
         let coordinate = CLLocationCoordinate2D(latitude: 51.509742561831395, longitude: -0.1335390878740101)
         let annotatione = MKPointAnnotation()
         annotatione.coordinate = coordinate
         
         mapView.addAnnotation(annotatione)
         */
        
        /*
         for place in places {
         //if (place["enabled"] == "1") { wiruirubtgiurtgiurtgniu;trguirtnguirtgiunrgtbnirutgniurtgbrwpuibguitrwbiurtbiutbruiwbtuiptrbuiwiutuiwgtbuibuiwgptbgrtpuiwgbuipw
         guard let placeLat = place["lat"] else {continue}
         guard let placeLon = place["lon"] else {continue}
         guard let latitude = Double(placeLat) else {continue}
         guard let longitude = Double(placeLon) else {continue}
         guard let title = place["title"] else {continue}
         
         //set location of the mural to coordinate
         let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
         let annotation = MKPointAnnotation()
         
         //make coordinate of the annotation the coordinate of the mural
         annotation.coordinate = coordinate
         
         //make the title of the annotation the title of the mural
         annotation.title = title
         
         //add the annotation to the map
         self.myMap.addAnnotation(annotation)
         
         
         }
         */
        /*
         func updateTheTable(){
         //set location of the mural to coordinate
         let coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
         let annotation = MKPointAnnotation()
         
         //make coordinate of the annotation the coordinate of the mural
         annotation.coordinate = coordinate
         
         //make the title of the annotation the title of the mural
         annotation.title = title
         
         //add the annotation to the map
         self.mapView.addAnnotation(annotation)
         }
         */
        
    }
}
