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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtFieldDeviceName.delegate = self
        self.txtFieldSerialNumbeer.delegate = self
        // Do any additional setup after loading the view.
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
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !self.setValidationForDevice() {return}
        self.viewModel.addDevice(srialNumber: self.txtFieldSerialNumbeer.text!, deviceName: self.txtFieldDeviceName.text!, viewController: self, isLoaderRequired: true) { status, msg in
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
       return true
    }
    
    
}
