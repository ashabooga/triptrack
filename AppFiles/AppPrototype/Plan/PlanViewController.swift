import UIKit
import CoreData

class PlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, UIBarPositioningDelegate {
    
    var cityList = [String]()
    var startDateList = [Date]()
    var endDateList = [Date]()
    var transportToTypeList = [String]()
    var transportToDateTimeList = [Date]()
    var transportFromTypeList = [String]()
    var transportFromDateTimeList = [Date]()
    var activitesTextEntryList = [String]()
    
    
    var plans = [["ID" : Int(), "city" : String(), "startDate" : Date(), "endDate" : Date(), "transportToType" : String(), "transportToDateTime" : Date(), "transportFromType" : String(), "transportFromDateTime" : Date(), "activitesTextEntry" : String()]] as [[String : Any]]
    
    //    var plans = [Dictionary<String, Any>()]
    
    var selectedPlan = ["ID" : Int(), "city" : String(), "startDate" : Date(), "endDate" : Date(), "transportToType" : String(), "transportToDateTime" : Date(), "transportFromType" : String(), "transportFromDateTime" : Date(), "activitesTextEntry" : String()] as [String : Any]
    
    var isSegueing = false
    var hasPlans = false
    
    @IBOutlet weak var planTable: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBAction func welcomeInfoButton(_ sender: Any) {
        performSegue(withIdentifier: "planToWelcome", sender: nil)
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if plans.count == 1 && plans[0]["city"] as! String == "" {
            return 0
        }
        else {
//            print(plans)
            return plans.count
        }
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
            
            self.selectedPlan = ["ID" : Int(), "city" : String(), "startDate" : Date(), "endDate" : Date(), "transportToType" : String(), "transportToDateTime" : Date(), "transportFromType" : String(), "transportFromDateTime" : Date(), "activitesTextEntry" : String()]
            
            PlanNewViewController.selectedPlan = selectedPlan
            PlanNewViewController.isNewPlan = true
            PlanNewViewController.segueFromController = "PlanViewController"
        }
        if segue.identifier == "toPlanDetail" {
            let PlanDetailViewController = segue.destination as! PlanDetailViewController
            
            PlanDetailViewController.selectedPlan = selectedPlan
        }
        if segue.identifier == "planToWelcome" {
            let WelcomeViewController = segue.destination as! WelcomeViewController
            WelcomeViewController.segueFromController = "PlanViewController"
        }
    }
    
    @IBAction func unwindToPlan(_ unwindSegue: UIStoryboardSegue) {
        //_ = unwindSegue.source
        
        
        if unwindSegue.source is PlanNewViewController {
            let PlanNewViewController = unwindSegue.source as! PlanNewViewController
            print(PlanNewViewController.selectedPlan)
            self.selectedPlan = PlanNewViewController.selectedPlan
            
            //if !(plans.count == 1 && plans[0]["city"] as? String == "")  {
              //  plans.remove(at: 0)
            //}
  
            if plans.count == 1 && plans[0]["city"] as! String == ""{
                plans.remove(at:0)
                plans.append(selectedPlan)
            }
            else if selectedPlan["city"] as! String != ""{
                plans.append(selectedPlan)
            }
            PlanNewViewController.isNewPlan = false
            
            
        } else if unwindSegue.source is PlanDetailViewController {
            let PlanDetailViewController = unwindSegue.source as! PlanDetailViewController
//            print(PlanDetailViewController.selectedPlan)
            self.selectedPlan = PlanDetailViewController.selectedPlan
            if selectedPlan["city"] as! String == ""{
                
            }
            else{
                let ID = selectedPlan["ID"] as! Int
                
                plans[ID] = selectedPlan
                
            }
        }
        
        planTable.reloadData()
        // Use data from the view controller which initiated the unwind segue
    }
    
    func saveCoreData() {
        do {
            try self.context.save()
        } catch {
            print("couldn't save core data")
        }
    }
    
    func deleteCoreData() {
        // create the delete request for the specified entity
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Plan.fetchRequest()
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
    
    func insertIntoCoreData() {
        print("inserting to core data LOOK HERE")
        deleteCoreData()
        var i = 0
        
        for _ in plans {
            print(plans[i]["city"]!)
            let newPlan = Plan(context: self.context)
            newPlan.city = plans[i]["city"] as? String
            newPlan.startDate = plans[i]["startDate"] as? Date
            newPlan.endDate = plans[i]["endDate"] as? Date
            newPlan.transportToType = plans[i]["transportToType"] as? String
            newPlan.transportToDateTime = plans[i]["transportToDateTime"] as? Date
            newPlan.transportFromType = plans[i]["transportFromType"] as? String
            newPlan.transportFromDateTime =  plans[i]["transportFromDateTime"] as? Date
            newPlan.activitesTextEntry = plans[i]["activitiesTextEntry"] as? String
            i+=1
            
            saveCoreData()
        }
        
    }
        
    func fetchCoreData() {
        print("fetching core data plan ")
        do {
            let myPlan = try context.fetch(Plan.fetchRequest())
//            var hasRun = false
            plans = [[:]]
            plans.remove(at: 0)
            var i = 0
            for entry in myPlan {
                
//                if entry.city == "" {
//                    continue
//                }
//
//                if !hasRun {
//                    plans.append([:])
//                } else {
//                    hasRun = true
//                }
                plans.append([:])
//                print(plans.count)
                
                plans[i]["city"] = entry.city
                plans[i]["startDate"] = entry.startDate
                plans[i]["endDate"] = entry.endDate
                plans[i]["transportToType"] = entry.transportToType
                plans[i]["transportToDateTime"] = entry.transportToDateTime
                plans[i]["transportFromType"] = entry.transportFromDateTime
                plans[i]["transportFromDateTime"] = entry.transportFromDateTime
                plans[i]["activitiesTextEntry"] = entry.activitesTextEntry
                
                i+=1
            }
            
        } catch {
            print("Couldn't fetch core data")
        }
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        if !isSegueing {
            print("dissapearing plan, inserting to core data")
            insertIntoCoreData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("appearing plan")
        
        if !isSegueing {
            fetchCoreData()
        } else {
            isSegueing = false
        }
        
        planTable.reloadData()
//            print(plans)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.delegate = self
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
