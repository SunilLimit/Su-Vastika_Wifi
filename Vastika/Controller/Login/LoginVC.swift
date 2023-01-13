//
//  LoginVC.swift
//  Vastika
//
//  Created by Mac on 13/09/21.
//

import UIKit

class LoginVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var btnRememberMe: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var scrlHeight: NSLayoutConstraint!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var txtFieldForgotMail: UITextField!
    @IBOutlet weak var btnForgotRequest: UIButton!
    
    var viewModel = loginViewModel()
    var checkReemebeer = false
    
    
    // MARK:- View Life Cycle ------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnLogin.layer.cornerRadius = self.btnLogin.frame.size.height/2
        self.btnLogin.clipsToBounds = true
        self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: 20)
        self.scrlHeight.constant = 190
        self.txtFieldPassword.delegate = self
        self.txtFieldEmail.delegate = self
        self.txtFieldForgotMail.delegate = self
        self.outerView.isHidden = true
        self.txtFieldPassword.enablePasswordToggle()
        self.txtFieldEmail.attributedPlaceholder = NSAttributedString(string: "Enter Mobile or Email ID",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.txtFieldPassword.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let email = UserDefaults.standard.object(forKey: "email") as? String
        if email == "" || email == nil
        {
            self.imgCheckBox.image = UIImage(named: "rememberpasswordBlank")
            self.txtFieldPassword.text = ""
            self.txtFieldEmail.text = ""
            print("not saved")
        }
        else
        {
            let password = UserDefaults.standard.object(forKey: "password") as? String
            self.txtFieldPassword.text = password ?? ""
            self.txtFieldEmail.text = email
            print("saved")
            self.imgCheckBox.image = UIImage(named: "rememberpassword")

        }
        
    }
    
    // MARK:- UIAction Method ------------
    
    @IBAction func tapLoginWithOtp(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "LogiWithOtpVC") as? LogiWithOtpVC{
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
        
    }
    
    func doStringContainsNumber( _string : String) -> Bool{

            let numberRegEx  = ".*[0-9]+.*"
            let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            let containsNumber = testCase.evaluate(with: _string)

            return containsNumber
            }
    
    func checkvalidation()-> Bool
    {
        
        let mobCheck =  self.txtFieldEmail.text?.first
        if mobCheck == "0"
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Mobile number does not started with 0 .", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if self.txtFieldEmail.text!.isNumeric
        {
            if !self.isValidMobileNumber(PhoneNumber: self.txtFieldEmail.text!)
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Please enter valid mob number .", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        else if (self.txtFieldEmail.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter email-Id .", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if !self.isValidEmailId(emailId: self.txtFieldEmail.text!)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter valid email-Id .", preferredStyle: UIAlertController.Style.alert)
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
        
        
        return true
    }
    
    func checkvalidationForForgotPassword()-> Bool
    {
        
        let mobCheck =  self.txtFieldForgotMail.text?.first
        if mobCheck == "0"
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Mobile number does not started with 0 .", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if self.txtFieldForgotMail.text!.isNumeric
        {
            if !self.isValidMobileNumber(PhoneNumber: self.txtFieldForgotMail.text!)
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Please enter valid mob number .", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        else if (self.txtFieldForgotMail.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter email-Id .", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if !self.isValidEmailId(emailId: self.txtFieldForgotMail.text!)
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
    
    @IBAction func tapRemembeerMe(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true
        {
            self.checkReemebeer = true
            self.imgCheckBox.image = UIImage(named: "rememberpassword")
            UserDefaults.standard.setValue(self.txtFieldEmail.text!, forKey: "email")
            UserDefaults.standard.setValue(self.txtFieldPassword.text!, forKey: "password")
            UserDefaults.standard.synchronize()
        }
        else
        {
            self.checkReemebeer = false
            self.imgCheckBox.image = UIImage(named: "rememberpasswordBlank")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    @IBAction func tapForgotPassword(_ sender: Any) {
        self.outerView.isHidden = false
    }
    
    @IBAction func tapLogin(_ sender: Any) {
        
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !self.checkvalidation() {return}
        self.viewModel.RequestLogin(email: self.txtFieldEmail.text!, password: self.txtFieldPassword.text!, viewController: self, isLoaderRequired: true) { status, obj in
            
            if status == "Success"
            {
                if self.checkReemebeer == true
                {
                    UserDefaults.standard.setValue(self.txtFieldEmail.text!, forKey: "email")
                    UserDefaults.standard.setValue(self.txtFieldPassword.text!, forKey: "password")
                    UserDefaults.standard.synchronize()
                }
                else
                {
                    UserDefaults.standard.removeObject(forKey: "email")
                    UserDefaults.standard.removeObject(forKey: "password")
                    UserDefaults.standard.synchronize()
                }
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.setHomeVieew()
                if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "OptionVC") as? OptionVC{
                    self.navigationController?.pushViewController(vcToPresent, animated: true);
                }
            }
            else
            {
                let alert = UIAlertController(title: webServices.AppName, message: obj, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tapSignup(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "NewSignUPVC") as? NewSignUPVC{
            self.navigationController?.pushViewController(vcToPresent, animated: true);
        }
    }
    
    func checkForgotEamilvalidation()-> Bool
    {
        if (self.txtFieldForgotMail.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter email-Id .", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if !self.isValidEmailId(emailId: self.txtFieldForgotMail.text!)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter valid email-Id .", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
       
        
        
        return true
    }
    
    @IBAction func tapForgotRequeest(_ sender: Any) {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !self.checkvalidationForForgotPassword() {return}
        self.viewModel.reequestForPassword(email: self.txtFieldForgotMail.text!, viewController: self, isLoaderRequired: true) { status, msg, key in
            if status == "Success"
            {
                let alert = UIAlertController(title: webServices.AppName, message: msg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.outerView.isHidden = true
                    self.txtFieldForgotMail.text = ""
                    if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "ForgotPasswordOTPVC") as? ForgotPasswordOTPVC{
                        vcToPresent.verifyKey = key
                        if !self.txtFieldForgotMail.text!.isNumeric
                        {
                            vcToPresent.isFrom = "email"
                        }
                        else
                        {
                            vcToPresent.isFrom = "mob"
                        }
                        
                        self.navigationController?.pushViewController(vcToPresent, animated: true);
                    }
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
    
    
    @IBAction func tapBackToLogin(_ sender: Any) {
        self.outerView.isHidden = true
        self.txtFieldForgotMail.text = ""
        self.view.endEditing(true)
        self.view.resignFirstResponder()
    }
    
    // MARK:- UITextFieldDelegate ---------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        self.txtFieldEmail.resignFirstResponder()
        self.txtFieldPassword.resignFirstResponder()
        self.txtFieldForgotMail.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == self.txtFieldEmail || textField == self.txtFieldPassword || textField == self.txtFieldForgotMail
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
        else if self.txtFieldEmail == textField || self.txtFieldForgotMail == textField
        {
            if self.txtFieldEmail.text!.isNumeric
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
        return true
    }
    
    
}

extension UITextField {
fileprivate func setPasswordToggleImage(_ button: UIButton) {
    if(isSecureTextEntry){
        button.setImage(UIImage(named: "eye"), for: .normal)
    }else{
        button.setImage(UIImage(named: "eye"), for: .normal)

    }
}

func enablePasswordToggle(){
    let button = UIButton(type: .custom)
    setPasswordToggleImage(button)
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
    button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
    self.rightView = button
    self.rightViewMode = .always
}
    @objc func togglePasswordView(_ sender: Any) {
    self.isSecureTextEntry = !self.isSecureTextEntry
    setPasswordToggleImage(sender as! UIButton)
}
}

extension String  {
    var isNumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
