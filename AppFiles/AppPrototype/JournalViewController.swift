import UIKit

class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var titleList = [String]()
    var locationList = [String]()
    var dateList = [Date]()
    var textEntryList = [String]()
    var photosList = [[UIImage]]()
    var photoIDsList = [[String]]()
    var latitudeList = [Float]()
    var longitudeList = [Float]()
    
    var selectedEntry = ["ID" : Int(), "title" : String(), "location" : String(), "latitude" : Float(), "longitude" : Float(), "date" : Date(), "textEntry" : String(), "photos" : [UIImage](), "photoIDs" : [String]()] as [String : Any]
    
    var hasBeenOpened = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var journalTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath)
        var content = UIListContentConfiguration.cell()
        content.text = titleList[indexPath.row]
        content.secondaryText = locationList[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEntry["ID"] = indexPath.row
        selectedEntry["title"] = titleList[indexPath.row]
        selectedEntry["location"] = locationList[indexPath.row]
        selectedEntry["date"] = dateList[indexPath.row]
        selectedEntry["textEntry"] = textEntryList[indexPath.row]
//        selectedEntry["photos"] = photosList[indexPath.row]
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
        
        print("segueing")
        
        if segue.identifier == "toNewEntry" {
            let JournalEntryViewController = segue.destination as! JournalEntryViewController
            JournalEntryViewController.segueFromController = "JournalViewController"
//            JournalEntryViewController.JournalVC = self
        }
        if segue.identifier == "toJournalDetail" {
            let JournalDetailViewController = segue.destination as! JournalDetailViewController
            JournalDetailViewController.selectedEntry = selectedEntry
            
        }
    }
    
    
    
    //Unwind segue called when back button pressed in second view controller
    @IBAction func unwindToJournal(_ unwindSegue: UIStoryboardSegue) {

        if unwindSegue.source is JournalEntryViewController {
            
            titleList.append(selectedEntry["title"] as? String ?? "No Title")
            locationList.append(selectedEntry["location"] as? String ?? "No Location")
            dateList.append(selectedEntry["date"] as? Date ?? Date())
            textEntryList.append(selectedEntry["textEntry"] as? String ?? "No Text Entry")
            latitudeList.append(selectedEntry["latitude"] as? Float ?? 0.0)
            longitudeList.append(selectedEntry["longitude"] as? Float ?? 0.0)
            
            //        photosList.append(selectedEntry["photos"] as? [UIImage] ?? [UIImage(named: "noImage")])
            if let selectedPhotos = selectedEntry["photos"] as? [UIImage] {
                photosList.append(selectedPhotos)
            } else {
                let noImage = UIImage(named: "noImage") ?? UIImage()
                photosList.append([noImage])
            }
            
            
        } else if unwindSegue.source is JournalDetailViewController {
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
            
            for entry in managedJournal {
                
                titleList.append(entry.titles!)
                locationList.append(entry.locationNames!)
                dateList.append(entry.dates!)
                textEntryList.append(entry.textEntries!)
                photosList.append([UIImage(named: "noImage")!])
                latitudeList.append(0.0)
                longitudeList.append(0.0)
                
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
    
    
    @objc func onTerminate() {
        print("terminating")
        
        let coreDataResults = try! self.context.fetch(Journal.fetchRequest())
        
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
        
            for coreDataResult in coreDataResults {
                self.context.delete(coreDataResult)
                saveCoreData()
            }
        
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onTerminate), name: UIScene.willDeactivateNotification, object: nil)
        
        if !hasBeenOpened {
            fetchCoreData()
            hasBeenOpened = true
        }
        
//        self.locationList = MapViewController.locationList
        
    }
    
    
    
    
}
