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
            
            //photosList.append(selectedEntry["photos"] as? [UIImage] ?? UIImage(named: "noImage"))
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
            
            print("UNWIND SHOULD BE FULL")
            print(selectedEntry["photos"]!)
            
            
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
                print("fetching")
                print(dataPhoto)

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
                            print("HERE ___----------")
                            print(photosList)
                            print("--------")
                            while photosList[0].isEmpty {
                                photosList.remove(at: 0)
                            }
                        }
                        
                        
                        
                        
                    } catch {
                        print("could not unarchive array: \(error)")
                    }
                }
                print("unarchived")
                print(photosList)
                
                latitudeList.append(0.0)
                longitudeList.append(0.0)
                
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
                print("binary")
                print(images!)
                
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
    
    
    
}
