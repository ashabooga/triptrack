import UIKit
import CoreData
import MapKit


class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIBarPositioningDelegate, UINavigationBarDelegate {
    
    var titleList = [String]()
    var locationList = [String]()
    var dateList = [Date]()
    var textEntryList = [String]()
    var photosList = [[UIImage]]()
    var photoIDsList = [[String]]()
    var latitudeList = [Double]()
    var longitudeList = [Double]()
    
    var subTitleList = [String]()
    
    var selectedEntry = ["ID" : Int(), "title" : String(), "location" : String(), "latitude" : Double(), "longitude" : Double(), "date" : Date(), "textEntry" : String(), "photos" : [UIImage](), "photoIDs" : [String]()] as [String : Any]
    
    var tempLocationString = String()
    
    var hasBeenOpened = false
    var isSegueing = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!

    
    @IBOutlet weak var journalTable: UITableView!
    
    
    @IBAction func welcomeInfoButton(_ sender: Any) {
        performSegue(withIdentifier: "journalToWelcome", sender: nil)
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath)
        var content = UIListContentConfiguration.cell()
        content.text = titleList[indexPath.row]
//        content.secondaryText = self.subTitleList[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEntry["ID"] = indexPath.row
        selectedEntry["title"] = titleList[indexPath.row]
        selectedEntry["location"] = locationList[indexPath.row]
        selectedEntry["date"] = dateList[indexPath.row]
        selectedEntry["textEntry"] = textEntryList[indexPath.row]
        selectedEntry["photos"] = photosList[indexPath.row]
        
        
        
        performSegue(withIdentifier: "toJournalDetail", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            titleList.remove(at: indexPath.row)
            locationList.remove(at: indexPath.row)
            dateList.remove(at: indexPath.row)
            textEntryList.remove(at: indexPath.row)
            photosList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    @IBAction func newEntryButton(_ sender: Any) {
        performSegue(withIdentifier: "toNewEntry", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        isSegueing = true
        
        if segue.identifier == "toNewEntry" {
            let JournalEntryViewController = segue.destination as! JournalEntryViewController
            JournalEntryViewController.segueFromController = "JournalViewController"
//            JournalEntryViewController.JournalVC = self
        }
        if segue.identifier == "toJournalDetail" {
            let JournalDetailViewController = segue.destination as! JournalDetailViewController
            JournalDetailViewController.segueFromController = "JournalViewController"
            JournalDetailViewController.selectedEntry = selectedEntry
            
        }
        if segue.identifier == "journalToWelcome" {
            let WelcomeViewController = segue.destination as! WelcomeViewController
            WelcomeViewController.segueFromController = "JournalViewController"
        }
    }
    
    
    
    //Unwind segue called when back button pressed in second view controller
    @IBAction func unwindToJournal(_ unwindSegue: UIStoryboardSegue) {

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
            
            GeocodeAddress(requests: ["city", "country"], latitude: selectedEntry["latitude"] as! Double, longitude: selectedEntry["longitude"] as! Double) { result in
                
                self.subTitleList.append(result)
            }
            
            //photosList.append(selectedEntry["photos"] as? [UIImage] ?? [UIImage(named: "noImage")])
            if let selectedPhotos = selectedEntry["photos"] as? [UIImage] {
                photosList.append(selectedPhotos)
            } else {
                let noImage = UIImage(named: "noImage") ?? UIImage()
                photosList.append([noImage])
            }
            
            
        } else if unwindSegue.source is JournalDetailViewController { // Might be redundant?
            let JournalDetailViewController = unwindSegue.source as! JournalDetailViewController
            self.selectedEntry = JournalDetailViewController.selectedEntry
            let id = selectedEntry["ID"] as! Int
            
            titleList[id] = selectedEntry["title"] as? String ?? "No Title"
            locationList[id] = selectedEntry["location"] as? String ?? "No Location"
            dateList[id] = selectedEntry["date"] as? Date ?? Date()
            textEntryList[id] = selectedEntry["textEntry"] as? String ?? "No Text Entry"
            
            if let selectedPhotos = selectedEntry["photos"] as? [UIImage] {
                photosList[id] = selectedPhotos
            } else {
                let noImage = UIImage(named: "noImage") ?? UIImage()
                photosList[id] = [noImage]
            }
        }
            
        
        journalTable.reloadData()
        // Use data from the view controller which initiated the unwind segue
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
            
            var dataPhoto = [[Data]()]
            
            for entry in managedJournal {
                
                titleList.append(entry.titles!)
                locationList.append(entry.locationNames!)
                dateList.append(entry.dates!)
                textEntryList.append(entry.textEntries!)
                dataPhoto.append([entry.photoLists ?? Data()])
                photosList.append(convertDataToImages(imageDataArray: dataPhoto[0]))
//                print(photosList)
                
                latitudeList.append(entry.latitudes)
                longitudeList.append(entry.longitudes)
                
//                photosList.append(entry.photoLists!)
                
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
                let myImagesDataArray = convertImageToData(myImagesArray: photosList[i])
                var images: Data?
                do {
                    images = try NSKeyedArchiver.archivedData(withRootObject: myImagesDataArray, requiringSecureCoding: true)
                } catch {
                    print("error")
                }
                newEntry.photoLists = images
                print("binary")
                print(images!)
                
                //            newEntry.photoLists = photosList[i]
                //            newEntry.photoIDLists = photoIDsList[i]
                saveCoreData()
            }
        }
    }
    
    
    func convertImageToData(myImagesArray: [UIImage]) -> [Data] {
      var myImagesDataArray = [Data]()
        myImagesArray.forEach({ (image) in myImagesDataArray.append(image.pngData()!)
      })
      return myImagesDataArray
    }
    
    
    func convertDataToImages(imageDataArray: [Data]) -> [UIImage] {
      var myImagesArray = [UIImage]()
        imageDataArray.forEach { imageData in myImagesArray.append(UIImage(data: imageData)!)
      }
      return myImagesArray
    }
    
    
    
    @objc func onTerminate() {
//        print("terminating")
        insertToCoreData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        print("disapperaing journal")
        insertToCoreData()
//        print(titleList.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isSegueing {
            fetchCoreData()
        } else {
            isSegueing = false
        }
        
        
        currentLocation = locManager.location
        journalTable.reloadData()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onTerminate), name: UIScene.willDeactivateNotification, object: nil)
        navigationBar.delegate = self
        
        if titleList.count > 1 {
            for i in Range(0...titleList.count-1) {
                GeocodeAddress(requests: ["city", "country"], latitude: latitudeList[i], longitude: longitudeList[i]) { result in
                    
                    DispatchQueue.main.sync {
                        self.subTitleList[i] = result
                    }
                }
            }
        } else if titleList.count == 1 {
            GeocodeAddress(requests: ["city", "country"], latitude: latitudeList[0], longitude: longitudeList[0]) { result in
                
                DispatchQueue.main.sync {
                    self.subTitleList[0] = result
                }
            }
        }
        
        
        
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
    }
    
    func GeocodeAddress(requests: [String], latitude: Double, longitude: Double, completion: @escaping (String) -> Void) {
        geocode(latitude: latitude, longitude: longitude) { placemark, error in
            guard let placemark = placemark, error == nil else {
                completion("") // Call completion with empty string if there was an error
                return
            }
            
            let country = placemark.country ?? "N/A"
            let addressName = placemark.thoroughfare ?? "N/A"
            let city = placemark.locality ?? "N/A"
            
            var output = ""
            
            if requests.count == 0 {
                completion("No input to call GeocodeAddress")
            } else if requests.count == 1 {
                if requests[0] == "city" {
                    completion(city)
                } else if requests[0] == "country" {
                    completion(country)
                } else if requests[0] == "addressName" {
                    completion(addressName)
                } else {
                    completion("Incorrect input to call GeocodeAddress")
                }
            } else {
                for request in requests {
                    if request == "city" {
                        output += city
                    } else if request == "country" {
                        output += country
                    } else if request == "addressName" {
                        output += addressName
                    }
                    
                    if request != requests.last {
                        output += ", "
                    }
                }
            }
            
            completion(output)
            
        }
    }
    
    
    
}
