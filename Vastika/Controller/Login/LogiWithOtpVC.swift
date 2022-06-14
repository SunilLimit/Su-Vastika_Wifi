//
//  LogiWithOtpVC.swift
//  Vastika
//
//  Created by Limitless on 11/04/22.
//

import UIKit

class LogiWithOtpVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var txtFieldMobNo: UITextField!
    @IBOutlet weak var btnOtp: UIButton!
    var viewModel = loginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnOtp.layer.cornerRadius = self.btnOtp.frame.size.height/2
        self.btnOtp.clipsToBounds = true
        self.txtFieldMobNo.delegate = self
        self.outerView.layer.cornerRadius = 10
        self.outerView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapLoginWithPassword(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
   
    @IBAction func tapRequestOtp(_ sender: Any) {
      
        if (self.txtFieldMobNo.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter mobile number.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let str = self.txtFieldMobNo.text!.prefix(1)
        if str == "0"
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Phone number will never be start from 0.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if !self.isValidMobileNumber(PhoneNumber: self.txtFieldMobNo.text!)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter valid mobile number.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            }))
            self.present(alert, animated: true, completion: nil)
            return 
        }
        
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        self.viewModel.reequestMobileLoginOTP(mob: self.txtFieldMobNo.text!, viewController: self, isLoaderRequired: true) { errorString, obj, key in
            
            if errorString == "Success"
            {
                if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "VerifyOTPViewController") as? VerifyOTPViewController{
                    vcToPresent.verifyKey = key
                    vcToPresent.isFrom = "mob"
                    vcToPresent.phoneNo = self.txtFieldMobNo.text!
                    self.navigationController?.pushViewController(vcToPresent, animated: true);
                }
            }
        }
        
    }
    
    @IBAction func tapSignup(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "NewSignUPVC") as? NewSignUPVC{
            self.navigationController?.pushViewController(vcToPresent, animated: true);
        }
    }
    
    //MARK:-  UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if self.txtFieldMobNo == textField
        {
            let maxLength = 10
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
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
   
}


