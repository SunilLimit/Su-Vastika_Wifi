//
//  NewSignUPVC.swift
//  Vastika
//
//  Created by Sanjeev on 08/06/22.
//

import UIKit

class NewSignUPVC: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldMobileEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var verifyView: UIView!
    @IBOutlet weak var lblDetails: UILabel!
    
    var viewModel = RegisterViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtFieldPassword.enablePasswordToggle()
        self.txtFieldName.delegate = self
        self.txtFieldPassword.delegate = self
        self.txtFieldMobileEmail.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func checkvalidation()-> Bool
    {
        if (self.txtFieldMobileEmail.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter Name .", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        let mobCheck =  self.txtFieldMobileEmail.text?.first
        if mobCheck == "0"
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Mobile number does not started with 0 .", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if self.txtFieldMobileEmail.text!.isNumeric
        {
            if !self.isValidMobileNumber(PhoneNumber: self.txtFieldMobileEmail.text!)
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Please enter valid mob number .", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
                return false
            }
            else if (self.txtFieldPassword.text?.isEmpty ?? true)
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Please enter password.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
                return false
            }
            
        }
        else if (self.txtFieldMobileEmail.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter email-Id .", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if !self.isValidEmailId(emailId: self.txtFieldMobileEmail.text!)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter valid email-Id .", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
       
        
        return true
    }
    
    func isValidEmailId(emailId email:String) -> Bool{
        
        let emailFormat =  "[A-Za-z0-9._%+-]{1,}+(\\.[_A-Za-z0-9-]+)*@"
            + "[A-Za-z]+(\\.[A-Za-z]+)*(\\.[A-Za-z]{2,})$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK:- Valid Mob number
    func isValidMobileNumber(PhoneNumber phno:String) ->Bool{
        let badcharacters = CharacterSet.decimalDigits.inverted
            guard phno.rangeOfCharacter(from: badcharacters) == nil else { return false}
            if  phno.count == 10 {
                let phoneNumberRegex = "^[6-9]\\d{9}$"
                let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
                let isValidPhone = phoneTest.evaluate(with: phno)
                return isValidPhone
            }
            else{
                return false
        }
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapSignIN(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapSignUp(_ sender: Any) {
        self.verifyView.isHidden = true
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !self.checkvalidation(){return}
        
        let dict = ["name"  : self.txtFieldName.text!,
                    "mobile_or_email" : self.txtFieldMobileEmail.text!,
                    "password" : self.txtFieldPassword.text!
                    ]
        
        self.viewModel.registerUpdatedUser(deetails: dict as NSDictionary, viewController: self, isLoaderRequired: true) { status, obj , vrifyKey in
            if status == "Success"
            {
                let alert = UIAlertController(title: webServices.AppName, message: obj, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.veerifyRgisterdEemail(key: vrifyKey, msg: obj)
                }))
                self.present(alert, animated: true, completion: nil)
             
            }
            else
            {
                let alert = UIAlertController(title: webServices.AppName, message: obj, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    //self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func tapSubmit(_ sender: Any) {
        if !self.checkvalidation(){return}

        self.verifyView.isHidden = false
        var strDetails = ""
        if self.txtFieldMobileEmail.text!.isNumeric
        {
            strDetails = "Name : " + self.txtFieldName.text! + "\n"
            strDetails = strDetails + "Mobile Number : " + self.txtFieldMobileEmail.text!
        }
        else
        {
            strDetails = "Name : " + self.txtFieldName.text! + "\n"
            strDetails = strDetails + "Email : " + self.txtFieldMobileEmail.text!
        }
        self.lblDetails.text = strDetails
    }
    
    func veerifyRgisterdEemail(key : String, msg : String)
    {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "VerifyOTPViewController") as? VerifyOTPViewController{
            vcToPresent.verifyKey = key
            self.navigationController?.pushViewController(vcToPresent, animated: true);
        }
        
      
    }
    
    //MARK:-  UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    
    // MARK:- UITextFieldDelegate ---------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        self.txtFieldName.resignFirstResponder()
        self.txtFieldPassword.resignFirstResponder()
        self.txtFieldMobileEmail.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == self.txtFieldMobileEmail || textField == self.txtFieldPassword || textField == self.txtFieldName
        {
            let rawString = string
                 let range = rawString.rangeOfCharacter(from: .whitespaces)
                if ((textField.text?.count)! == 0 && range  != nil)
                || ((textField.text?.count)! > 0 && textField.text?.last  == " " && range != nil)  {
                    return false
                }
        }
        if self.txtFieldPassword == textField
        {
            let maxLength = 4
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if self.txtFieldMobileEmail == textField || self.txtFieldMobileEmail == textField
        {
            if self.txtFieldMobileEmail.text!.isNumeric
            {
                let maxLength = 10
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            else
            {
                let maxLength = 30
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
           
        }
        else if self.txtFieldName == textField
        {
            let maxLength = 30
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
    
    
}
