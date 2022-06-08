//
//  FeedbackVC.swift
//  Vastika
//
//  Created by Mac on 24/09/21.
//

import UIKit

class FeedbackVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var txtFieldMessage: UITextField!
    @IBOutlet weak var txtFieldDevice: UITextField!
    @IBOutlet weak var txtFieldTitle: UITextField!
    
    var pickerView = UIPickerView()
    var toolBar = UIToolbar()
    var arrayOfDeviceList = [HomeModel]()
    var deviceId = String()
    var viewModel = HomeViewModel()

    // MARK:- View Life Cycle ----------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDelegate()
        self.setUpPicker()
        self.callServiceForDeviceList()
        // Do any additional setup after loading the view.
    }
    
    func callServiceForDeviceList()
    {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.arrayOfDeviceList.removeAll()
        self.viewModel.getProductList(page: "1", viewController: self, isLoaderRequired: true) { status, obj in
            if status == "Success"
            {
                self.arrayOfDeviceList = obj
            }
        }
    }
    
    // MARK:- Setup Delegat ---------
    
    func setupDelegate()
    {
        self.txtFieldTitle.delegate = self
        self.txtFieldDevice.delegate = self
        self.txtFieldMessage.delegate = self
    }
    
    // MARK:- Setup Picker ---------

    func setUpPicker()
    {
        pickerView.delegate = self
        pickerView.dataSource = self
               
        self.txtFieldDevice.inputView = pickerView

       toolBar.barStyle = UIBarStyle.default
       toolBar.isTranslucent = true
       toolBar.tintColor = UIColor.init(red: 103/255, green: 48/255, blue: 197/255, alpha: 1)
       toolBar.sizeToFit()
       
       let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
       
       let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
       
       let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
       
       toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
       toolBar.isUserInteractionEnabled = true
               
        self.txtFieldDevice.inputAccessoryView = toolBar
       

}
    
    @objc func donePicker() {
        self.txtFieldDevice.resignFirstResponder()
        self.txtFieldTitle.resignFirstResponder()
        self.txtFieldMessage.resignFirstResponder()

    }
            
    @objc func cancelPicker()
    {
        self.txtFieldDevice.resignFirstResponder()
        self.txtFieldTitle.resignFirstResponder()
        self.txtFieldMessage.resignFirstResponder()
    }
    
    // MARK:- Set Validation on Fields ------------
    
    func checkValidation()-> Bool
    {
        if (self.txtFieldDevice.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please select device.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if (self.txtFieldTitle.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter title.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if (self.txtFieldMessage.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter message.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    // MARK:- UIAction Method ----------
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapSubmit(_ sender: Any) {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !self.checkValidation() {return}
        self.viewModel.submitFeedback(deviceId: self.deviceId, title: self.txtFieldTitle.text!, message: self.txtFieldMessage.text!, viewController: self, isLoaderRequired: true) { status, msg in
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
                   
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK:- UITextFieldDelegate ---------
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtFieldDevice
        {
            if self.arrayOfDeviceList.count != 0
            {
                self.pickerView.reloadAllComponents()
            }
            else
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Device List not available.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.txtFieldTitle == textField 
        {
            let maxLength = 50
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if self.txtFieldMessage == textField
        {
            let maxLength = 200
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
    //=====================================================
     // MARK: - UIPickerView delegate datasource method
     //=====================================================
     
     
     func numberOfComponents(in pickerVitew: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
     {
        return self.arrayOfDeviceList.count
     }
     
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          
        var value = String()
        value = self.arrayOfDeviceList[row].device_name
        return value
     }
     
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtFieldDevice.text = self.arrayOfDeviceList[row].device_name
        self.deviceId = String(self.arrayOfDeviceList[row].device_id)
     }
}
