//
//  JournalEntryViewController.swift
//  AppPrototype
//
//  Created by Witkowska, Natalia on 13/03/2023.
//

import UIKit

class JournalEntryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var countryPicker: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var imageTest: UIImageView!
    
    @IBOutlet weak var thoughtTextView: UITextView!
    
    
    var imagePicker = UIImagePickerController()
    var selectedCountry: String?
    var countryList = ["Algeria", "Andorra", "Angola", "India", "Thailand"]
    var currentDate = Date()
    
    
    
    @IBAction func addPhotoButton(_ sender: Any) {
        print(currentDate)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {fatalError("bad")}
        imageTest.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
    
    func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           countryPicker.inputView = pickerView
    }
    
    
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       countryPicker.inputAccessoryView = toolBar
    }
    
    @objc func action() {
          view.endEditing(true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = currentDate
        createPickerView()
        dismissPickerView()
        
        
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
