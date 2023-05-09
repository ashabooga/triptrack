import CoreLocation
import CoreData
import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate, UINavigationBarDelegate, UIBarPositioningDelegate {
    
    var titleList = [String]()
    var locationList = [String]()
    var dateList = [Date]()
    var textEntryList = [String]()
    var photosList = [[UIImage]]()
    var photoIDsList = [[String]]()
    var latitudeList = [Double]()
    var longitudeList = [Double]()
    var annotationList = [MKPointAnnotation]()
    var indexPat = Int()
    
    var isSegueing = false
    
    var tempLatitude = Double()
    var tempLongitude = Double()
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var selectedEntry = ["ID" : Int(), "title" : String(), "location" : String(), "latitude" : Double(), "longitude" : Double(), "date" : Date(), "textEntry" : String(), "photos" : [UIImage](), "photoIDs" : [String]()] as [String : Any]
    
    @IBOutlet weak var mapView: MKMapView!
    
    //    selectedEntry["ID"] = 6
    //    selectedEntry["latidute"] = latitudeList[6]
    
    var userLocation = CLLocation()
    var locationManager = CLLocationManager()
    var firstRun = true
    var startTrackingTheUser = false
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "toNew" {
    //            let JournalEntryViewController = segue.destination as! JournalEntryViewController
    //            JournalEntryViewController.segueFromController = "MapViewController"
    //        }
    //    }
    
    @IBAction func welcomeInfoButton(_ sender: Any) {
        performSegue(withIdentifier: "mapToWelcome", sender: nil)
    }
    
    
    
    
    //Unwind segue called when back button pressed in second view controller
    @IBAction func unwindToMap(_ unwindSegue: UIStoryboardSegue) {
        
        if unwindSegue.source is JournalEntryViewController { // This is all bad
            let JournalEntryViewController = unwindSegue.source as! JournalEntryViewController
            self.selectedEntry = JournalEntryViewController.selectedEntry
            
            fetchCoreData()
            
            titleList.append(selectedEntry["title"] as? String ?? "No Title")
            locationList.append(selectedEntry["location"] as? String ?? "No Location")
            dateList.append(selectedEntry["date"] as? Date ?? Date())
            textEntryList.append(selectedEntry["textEntry"] as? String ?? "No Text Entry")
            latitudeList.append(selectedEntry["latitude"] as? Double ?? 0.0)
            longitudeList.append(selectedEntry["longitude"] as? Double ?? 0.0)
            
            //        photosList.append(selectedEntry["photos"] as? [UIImage] ?? [UIImage(named: "noImage")])
            if let selectedPhotos = selectedEntry["photos"] as? [UIImage] {
                photosList.append(selectedPhotos)
            } else {
                let noImage = UIImage(named: "noImage") ?? UIImage()
                photosList.append([noImage])
            }
            
            if titleList.count > 0 {
                while photosList[0].isEmpty {
                    photosList.remove(at: 0)
                }
            }
            
            
            
        } else if unwindSegue.source is JournalDetailViewController {
            let JournalDetailViewController = unwindSegue.source as! JournalDetailViewController
            self.selectedEntry = JournalDetailViewController.selectedEntry
            let id = selectedEntry["ID"] as! Int
            
            titleList[id] = selectedEntry["title"] as? String ?? "No Title"
            locationList[id] = selectedEntry["location"] as? String ?? "No Location"
            dateList[id] = selectedEntry["date"] as? Date ?? Date()
            textEntryList[id] = selectedEntry["textEntry"] as? String ?? "No Text Entry"
            latitudeList[id] = selectedEntry["latitude"] as? Double ?? userLocation.coordinate.latitude
            longitudeList[id] = selectedEntry["longitude"] as? Double ?? userLocation.coordinate.longitude
            
            if let selectedPhotos = selectedEntry["photos"] as? [UIImage] {
                photosList[id] = selectedPhotos
            } else {
                let noImage = UIImage(named: "noImage") ?? UIImage()
                photosList[id] = [noImage]
            }
        }
        
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
        tempLatitude = locationManager.location?.coordinate.latitude ?? 0.0
        tempLongitude = locationManager.location?.coordinate.longitude ?? 0.0
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
            
            tempLatitude = locationCoordinate.latitude
            tempLongitude = locationCoordinate.longitude
        
            mapView.addAnnotation(annotation)
            
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
        
        isSegueing = true
        
        selectedEntry = ["ID" : Int(), "title" : String(), "location" : String(), "latitude" : Double(), "longitude" : Double(), "date" : Date(), "textEntry" : String(), "photos" : [UIImage](), "photoIDs" : [String]()] as [String : Any]
        
        if segue.identifier == "mapToDetailJournal" {
        
            
            let JournalDetailViewController = segue.destination as! JournalDetailViewController
            
            selectedEntry["ID"] = indexPat
            selectedEntry["title"] = titleList[indexPat]
            selectedEntry["location"] = locationList[indexPat]
            selectedEntry["latitude"] = latitudeList[indexPat]
            selectedEntry["longitude"] = longitudeList[indexPat]
            selectedEntry["date"] = dateList[indexPat]
            selectedEntry["textEntry"] = textEntryList[indexPat]
            selectedEntry["photos"] = photosList[indexPat]
//            selectedEntry["photoIDs"] = photoIDsList[indexPat]
            
            
            
            JournalDetailViewController.selectedEntry = self.selectedEntry
            print(self.selectedEntry)
            JournalDetailViewController.segueFromController = "MapViewController"
        } else if segue.identifier == "mapToWelcome" {
            let WelcomeViewController = segue.destination as! WelcomeViewController
            WelcomeViewController.segueFromController = "MapViewController"
        } else {
            let JournalEntryViewController = segue.destination as! JournalEntryViewController
            JournalEntryViewController.segueFromController = "MapViewController"
            
            if tempLatitude != 0.0 {
                selectedEntry["latitude"] = tempLatitude
                selectedEntry["longitude"] = tempLongitude
                JournalEntryViewController.selectedEntry = self.selectedEntry
            }
            
            
        }
        
    }
    
    func fetchCoreData() {
        
        do {
            let managedJournal = try context.fetch(Journal.fetchRequest())
            
            titleList = []
            locationList = []
            dateList = []
            textEntryList = []
            photosList = []
            latitudeList = []
            longitudeList = []
            photosList = [[]]
            
            var dataPhoto = [Data]()
            
            for entry in managedJournal {
                
                titleList.append(entry.titles!)
                locationList.append(entry.locationNames!)
                dateList.append(entry.dates!)
                textEntryList.append(entry.textEntries!)
                dataPhoto.append(entry.photoLists ?? Data())
                latitudeList.append(entry.latitudes)
                longitudeList.append(entry.longitudes)

                dataPhoto.forEach { (imageData) in
                    do {
                        let dataArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(imageData) as? [Data] ?? []
                        var imageArray: [UIImage] = []
                        for data in dataArray {
                            if let image = UIImage(data: data) {
                                imageArray.append(image)
                            }
                        }
                        
                        photosList.append(imageArray)
                        
                        if titleList.count > 0 {
                            while photosList[0].isEmpty {
                                photosList.remove(at: 0)
                            }
                        }
                        
                        
                        
                        
                    } catch {
                        print("could not unarchive array: \(error)")
                    }
                }
                
            }
            
        } catch {
            print("Couldn't fetch core data")
        }
    }
    
    func deleteCoreData() {
        // create the delete request for the specified entity
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Journal.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        // get reference to the persistent container
        let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer

        // perform the delete
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
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
        deleteCoreData()
        
        if titleList.count > 0 {
            
            for i in 0...titleList.count-1 {
                let newEntry = Journal(context: self.context)
                
                newEntry.titles = titleList[i]
                newEntry.locationNames = locationList[i]
                newEntry.latitudes = latitudeList[i]
                newEntry.longitudes = longitudeList[i]
                newEntry.dates = dateList[i]
                newEntry.textEntries = textEntryList[i]
                

                //to store array of images using encoding
                
                print("insert")
                print(photosList)
                let myImagesDataArray = convertImageToData(myImagesArray: photosList[i])
                print("first convert")
                print(photosList)
                print(myImagesDataArray)
                
                
                var images: Data?
                do {
                    images = try NSKeyedArchiver.archivedData(withRootObject: myImagesDataArray, requiringSecureCoding: false)
                    // save the encoded data to Core Data
                } catch {
                    print("Error encoding images array: \(error.localizedDescription)")
                }
                newEntry.photoLists = images
//                print("binary")
//                print(images!)
                
                //            newEntry.photoLists = photosList[i]
                //            newEntry.photoIDLists = photoIDsList[i]
                saveCoreData()
            }
        }
    }
    
    
    func convertImageToData(myImagesArray: [UIImage]) -> [Data] {
        var dataArray = [Data]()
        for image in myImagesArray {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                dataArray.append(imageData)
            }
        }
      return dataArray
    }
    
    
    func convertDataToImages(imageDataArray: [Data]) -> [UIImage] {
      var myImagesArray = [UIImage]()
        imageDataArray.forEach({ (dataImage) in myImagesArray.append(UIImage(data: dataImage) ?? UIImage(named: "noImage")!)})
      return myImagesArray
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("disapperaing map")
        
        insertToCoreData()
        print(titleList.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("appearing map")
        
        
        if !isSegueing{
            fetchCoreData()
        } else {
            isSegueing = false
        }
        print(titleList.count)
        
        for i in 0..<latitudeList.count {
            let coordinate = CLLocationCoordinate2D(latitude: latitudeList[i], longitude: longitudeList[i])
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = titleList[i]
            mapView.addAnnotation(annotation)
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.bool(forKey: "hasLaunchedBefore") {

        } else {
            // App is running for the first time
            defaults.set(true, forKey: "hasLaunchedBefore")
            //performSegue(withIdentifier: "welcome", sender: nil) change this to whatever the id is for the segue
        }
        navigationBar.delegate = self
        
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
        
    }
}
