//
//  JournalEntryViewController.swift
//  AppPrototype
//
//  Created by Witkowska, Natalia on 13/03/2023.
//

import UIKit
import PhotosUI

class JournalEntryViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate, UIScrollViewDelegate{
    
    
    var selectedEntry = ["ID" : Int(), "title" : String(), "location" : String(), "date" : Date(), "textEntry" : String(), "photos" : [UIImage]()] as [String : Any]
    var isNewEntry = false
    
    var imagePicker = UIImagePickerController()
    var selectedCountry: String?
    var countryList = ["Algeria", "Andorra", "Angola", "India", "Thailand"]
    var currentDate = Date()
    var imageList = [UIImage]()
    var page = UIPageControl()
    var isCreated = false
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var thoughtTextView: UITextView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBAction func saveButton(_ sender: Any) {

        selectedEntry["title"] = titleText.text
//        selectedEntry["location"] = "LOCATION"
        selectedEntry["date"] = datePicker.date
        selectedEntry["textEntry"] = thoughtTextView.text
        selectedEntry["photos"] = imageList
    }
    
    
    @IBAction func addPhotoButton(_ sender: Any) {
        print(currentDate)
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 5
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int((scrollView.contentOffset.x / pageWidth).rounded())
        
        // Update the current page of the page control
        page.currentPage = currentPage
    }
    
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        
        let dispatchGroup = DispatchGroup()  // Create a new dispatch group
        
        for result in results {
            dispatchGroup.enter()  // Notify the group that a task will be added
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self, let image = image as? UIImage else {
                    dispatchGroup.leave()  // Notify the group that the task is done
                    return
                }
                
                
                //for i in 0..<self.imageList.count {
                    //for j in i+1..<self.imageList.count {
                        //if self.imageList[i] != self.imageList[j] {
                            self.imageList.append(image)
                        //}
                    //}
                //}
                
                
                dispatchGroup.leave()  // Notify the group that the task is done
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {  // Called after all tasks are done
            self.buttonFinished()
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let JournalViewController = segue.destination as? JournalViewController {
            JournalViewController.selectedEntry = self.selectedEntry
        }
    }
    
    
    
    func buttonFinished() {
        // Create a UIScrollView

        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 579, width: 390, height: 265))
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: scrollView.frame.maxY - 50, width: view.frame.width, height: 50))
            
        scrollView.backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
            
            
        pageControl.numberOfPages = imageList.count
        pageControl.currentPage = 0
        page = pageControl
        view.addSubview(scrollView)
        view.addSubview(pageControl)
            
            // Add UIImageViews to the UIScrollView based on the imageList array
        for index in 0..<self.imageList.count {
            let imageView = UIImageView(frame: CGRect(x: scrollView.frame.width * CGFloat(index), y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
                //imageView.contentMode = .scaleAspectFit
            
            imageView.image = self.imageList[index]
            scrollView.addSubview(imageView)
        }
            
            // Set the content size of the UIScrollView based on the number of images
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(imageList.count), height: scrollView.frame.height)
            
        scrollView.delegate = self
        scrollView.bringSubviewToFront(pageControl)
            
        photoButton.frame.origin = CGPoint(x: 240, y: 530)
        photoButton.frame.size = CGSize(width: 130, height: 40)
            //photoButton.titleLabel!.font = UIFont.systemFont(ofSize: 17)
        
        
    }

    // MARK: UIScrollViewDelegate



    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = currentDate
        
        if !isNewEntry {
            thoughtTextView.text = (selectedEntry["textEntry"] as! String)
            navigationTitle.title = "EDIT ENTRY"
            //country.text = (selectedEntry["country"] as! String)
            datePicker.date = (selectedEntry["date"] as! Date)
        } else {
            navigationTitle.title = "NEW ENTRY"
        }

        
    
        
    }
    
    

}
