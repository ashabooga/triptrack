import UIKit

class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var test = ["hi", "hello", "testing"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath)
        var content = UIListContentConfiguration.cell()
        content.text = test[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toJournalDetail", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            test.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    
    //Unwind segue called when back button pressed in second view controller
    @IBAction func unwindToVC(_ unwindSegue: UIStoryboardSegue) {

        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
}
