//
//  JournalDetailViewController.swift
//  AppPrototype
//
//  Created by Witkowska, Natalia on 10/03/2023.
//

import UIKit

class JournalDetailViewController: UIViewController {
    
    var selectedEntry = ["ID" : Int(), "title" : String(), "location" : String(), "date" : Date(), "textEntry" : String(), "photos" : [UIImage]()] as [String : Any]

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textEntry: UITextView!
    @IBOutlet weak var photoView: UIImageView!
    
    let dateFormatter = DateFormatter()
    var photoList = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .long
        titleLabel.text = selectedEntry["title"] as? String
        locationLabel.text = selectedEntry["location"] as? String
        let date = selectedEntry["date"] as? Date
        let StringDate = dateFormatter.string(from: date!)
        dateLabel.text = StringDate
        textEntry.text = selectedEntry["textEntry"] as? String
        photoList = (selectedEntry["photos"] as? [UIImage])!
        photoView.image = photoList[0]
        

        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
