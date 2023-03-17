import UIKit

class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var titleList = [String]()
    var locationList = [String]()
    var dateList = [Date]()
    var textEntryList = [String]()
    var photosList = [[UIImage]]()
    
    var selectedEntry = ["ID" : Int(), "title" : String(), "location" : String(), "date" : Date(), "textEntry" : String(), "photos" : [UIImage]()] as [String : Any]
    
    
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
        if segue.identifier == "toNewEntry" {
            let JournalEntryViewController = segue.destination as! JournalEntryViewController
            JournalEntryViewController.isNewEntry = true
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
}
