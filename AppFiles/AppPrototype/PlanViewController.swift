import UIKit

class PlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var plans = [["ID" : Int(), "city" : String(), "startDate" : Date(), "endDate" : Date(), "transportToType" : String(), "transportToDateTime" : Date(), "transportFromType" : String(), "transportFromDateTime" : Date(), "activitesTextEntry" : String()]] as [[String : Any]]
    
//    var plans = [Dictionary<String, Any>()]
    
    var selectedPlan = ["ID" : Int(), "city" : String(), "startDate" : Date(), "endDate" : Date(), "transportToType" : String(), "transportToDateTime" : Date(), "transportFromType" : String(), "transportFromDateTime" : Date(), "activitesTextEntry" : String()] as [String : Any]
    
    var isSegueing = false
    var hasPlans = false
    
    @IBOutlet weak var planTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath)
        var content = UIListContentConfiguration.cell()
        content.text = plans[indexPath.row]["city"] as? String
        cell.contentConfiguration = content
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPlan = plans[indexPath.row]
        performSegue(withIdentifier: "toPlanDetail", sender: nil)
    }
    
    
    @IBAction func newPlanButton(_ sender: Any) {
        performSegue(withIdentifier: "toNewPlan", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            plans.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        isSegueing = true
        
        if segue.identifier == "toNewPlan" {
            let PlanNewViewController = segue.destination as! PlanNewViewController
            
            PlanNewViewController.selectedPlan = self.selectedPlan
            PlanNewViewController.isNewPlan = true
        }
    }
    
    @IBAction func unwindToPlan(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        
        
        if unwindSegue.source is PlanNewViewController {
            let PlanNewViewController = unwindSegue.source as! PlanNewViewController
            let id = selectedPlan["ID"] as! Int
            
            if !(plans.count == 1 && plans[0]["city"] as? String == "")  {
                plans.remove(at: 0)
            }
            
            plans.append(PlanNewViewController.selectedPlan)
            
            PlanNewViewController.isNewPlan = false
            
            
        }
        
        
        // Use data from the view controller which initiated the unwind segue
    }
    
    func insertIntoCoreData() {
        
    }
    
    func fetchCoreData() {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !isSegueing {
            print("dissapearing plan, inserting to core data")
            insertIntoCoreData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("appearing plan")
        
        fetchCoreData()
        planTable.reloadData()
        print(plans)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
