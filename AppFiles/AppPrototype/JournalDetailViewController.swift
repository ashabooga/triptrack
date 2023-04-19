//
//  JournalDetailViewController.swift
//  AppPrototype
//
//  Created by Witkowska, Natalia on 10/03/2023.
//

import UIKit

class JournalDetailViewController: UIViewController, UIScrollViewDelegate  {
    
    var selectedEntry = ["ID" : Int(), "title" : String(), "location" : String(), "date" : Date(), "textEntry" : String(), "photos" : [UIImage]()] as [String : Any]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textEntry: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let dateFormatter = DateFormatter()
    var photoList = [UIImage]()
    
    
    
    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: "toEdit", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEdit" {
            let JournalEntryViewController = segue.destination as! JournalEntryViewController
            JournalEntryViewController.selectedEntry = selectedEntry
            JournalEntryViewController.segueFromController = "JournalDetailViewController"
        }
    }
    
    //Unwind segue called when back button pressed in second view controller
    @IBAction func unwindToDetail(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    
    //func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //let page = scrollView.contentOffset.x/scrollView.frame.size.width
      //  pageControl.currentPage = Int(page)
    //}
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int((scrollView.contentOffset.x / pageWidth).rounded())
        // Update the current page of the page control
        pageControl.currentPage = currentPage
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateFormatter.dateStyle = .long
        titleLabel.text = selectedEntry["title"] as? String
        locationLabel.text = selectedEntry["location"] as? String
        let date = selectedEntry["date"] as? Date
        let StringDate = dateFormatter.string(from: date!)
        dateLabel.text = StringDate
        textEntry.text = selectedEntry["textEntry"] as? String
        photoList = (selectedEntry["photos"] as? [UIImage])!
        //photoView.image = photoList[0]
        
        
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        pageControl.numberOfPages = photoList.count
        
        
        for index in 0..<photoList.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            let imageView = UIImageView(frame: frame)
            imageView.image = photoList[index]
            self.scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(photoList.count), height: scrollView.frame.size.height)
        scrollView.delegate = self
        scrollView.bringSubviewToFront(pageControl)
        

    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .long
        titleLabel.text = selectedEntry["title"] as? String
        locationLabel.text = selectedEntry["location"] as? String
        let date = selectedEntry["date"] as? Date ?? Date()
        let StringDate = dateFormatter.string(from: date)
        dateLabel.text = StringDate
        textEntry.text = selectedEntry["textEntry"] as? String
        photoList = (selectedEntry["photos"] as? [UIImage]) ?? [UIImage(named: "noImage")!]
        //photoView.image = photoList[0]
        
        
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        pageControl.numberOfPages = photoList.count
        
        
        for index in 0..<photoList.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            let imageView = UIImageView(frame: frame)
            imageView.image = photoList[index]
            self.scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(photoList.count), height: scrollView.frame.size.height)
        scrollView.delegate = self
        scrollView.bringSubviewToFront(pageControl)
        

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
