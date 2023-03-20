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
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var page = scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage = Int(page)
    }
    
    
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
        //photoView.image = photoList[0]
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
                
        for index in 0..<photoList.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            let imageView = UIImageView(frame: frame)
            imageView.image = photoList[index]
            self.scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(photoList.count), height: scrollView.frame.size.height)
        scrollView.delegate = self
        print(photoList)
        

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
