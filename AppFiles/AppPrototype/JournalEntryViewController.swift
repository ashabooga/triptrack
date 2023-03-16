//
//  JournalEntryViewController.swift
//  AppPrototype
//
//  Created by Witkowska, Natalia on 13/03/2023.
//

import UIKit
import PhotosUI

class JournalEntryViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    @IBOutlet weak var countryPicker: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var imageTest: UIImageView!
    
    @IBOutlet weak var thoughtTextView: UITextView!
    
    
    var imagePicker = UIImagePickerController()
    var selectedCountry: String?
    var countryList = ["Algeria", "Andorra", "Angola", "India", "Thailand"]
    var currentDate = Date()
    var imageList = [UIImage]()
    
    
    
    @IBAction func addPhotoButton(_ sender: Any) {
        print(currentDate)
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 5
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            dismiss(animated: true, completion: nil)
            
        
        for result in results {
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self, let image = image as? UIImage else { return }
                
                self.imageList.append(image)
                
                DispatchQueue.main.async {
                    self.imagesPicked()
                }
            }
        }
    }
    
    
    func imagesPicked() {
        imageTest.image = imageList[0]
//        print(imageList)
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }

     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return countryList.count
     }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryList[row]
         
     }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = countryList[row] // selected item
        countryPicker.text = selectedCountry
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = currentDate
        
    }

}
