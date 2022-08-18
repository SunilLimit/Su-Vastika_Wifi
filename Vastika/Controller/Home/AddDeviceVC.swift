//
//  AddDeviceVC.swift
//  Vastika
//
//  Created by Mac on 22/09/21.
//

import UIKit

class AddDeviceVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtFieldDeviceName: UITextField!
    @IBOutlet weak var txtFieldSerialNumbeer: UITextField!
    var viewModel = HomeViewModel()
    @IBOutlet weak var txtFieldCharge: UITextField!
    var toolBar = UIToolbar()
    var isFrom = String()
    var homeMoel : HomeModel!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtFieldDeviceName.delegate = self
        self.txtFieldSerialNumbeer.delegate = self
        self.txtFieldCharge.delegate = self
        self.setUpPicker()
        if self.isFrom == "Edit"
        {
            print(homeMoel.device_name)
            self.txtFieldCharge.text = homeMoel.electricity_unit_charge
            self.txtFieldDeviceName.text = homeMoel.device_name
            self.txtFieldSerialNumbeer.text = homeMoel.serial_number
            self.btnAdd.setTitle("Update", for: .normal)
            self.lblTitle.text = "Update Device"
            self.txtFieldSerialNumbeer.isUserInteractionEnabled = false
        }
        else
        {
            self.txtFieldCharge.text = ""
            self.txtFieldDeviceName.text = ""
            self.txtFieldSerialNumbeer.text = ""
            self.btnAdd.setTitle("Submit", for: .normal)
            self.lblTitle.text = "Add Device"
            self.txtFieldSerialNumbeer.isUserInteractionEnabled = true
        }
        // Do any additional setup after loading the view.
    }
    
    
    func setUpPicker()
    {
       

       toolBar.barStyle = UIBarStyle.default
       toolBar.isTranslucent = true
       toolBar.tintColor = UIColor.init(red: 103/255, green: 48/255, blue: 197/255, alpha: 1)
       toolBar.sizeToFit()
       
       let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
       
       let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
       
       let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
       
       toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
       toolBar.isUserInteractionEnabled = true
               
        self.txtFieldCharge.inputAccessoryView = toolBar
       

}
    
    @objc func donePicker() {
        self.txtFieldCharge.resignFirstResponder()
        self.txtFieldDeviceName.resignFirstResponder()
        self.txtFieldSerialNumbeer.resignFirstResponder()

    }
            
    @objc func cancelPicker()
    {
        self.txtFieldCharge.resignFirstResponder()
        self.txtFieldDeviceName.resignFirstResponder()
        self.txtFieldSerialNumbeer.resignFirstResponder()
    }
    
    // MARK:- Set Validation -------------
    
    func setValidationForDevice()-> Bool
    {
        if (self.txtFieldDeviceName.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter device name.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if (self.txtFieldSerialNumbeer.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter serial number.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
       
        return true
    }
    
    @IBAction func tapback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapAdd(_ sender: Any) {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !self.setValidationForDevice() {return}
        self.viewModel.addDevice(srialNumber: self.txtFieldSerialNumbeer.text!, deviceName: self.txtFieldDeviceName.text!, charge: self.txtFieldCharge.text!,type:self.isFrom,viewController: self, isLoaderRequired: true) { status, msg in
            if status == "Success"
            {
                let alert = UIAlertController(title: webServices.AppName, message: msg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: webServices.AppName, message: msg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.txtFieldDeviceName.text = ""
                    self.txtFieldSerialNumbeer.text = ""
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK:- UItextField Delegate -----------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.view.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.txtFieldDeviceName == textField || self.txtFieldSerialNumbeer == textField
        {
            let maxLength = 50
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if self.txtFieldCharge == textField
        {
            let maxLength = 4
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
       return true
    }
    
    
}
