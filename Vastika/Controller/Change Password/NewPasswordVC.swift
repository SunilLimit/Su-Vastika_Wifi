//
//  NewPasswordVC.swift
//  Vastika
//
//  Created by Sanjeev on 08/06/22.
//

import UIKit

class NewPasswordVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!
    @IBOutlet weak var txtFieldNewPassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    var token = String()
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSubmit.layer.cornerRadius = self.btnSubmit.frame.size.height/2
        self.btnSubmit.clipsToBounds = true
        self.txtFieldConfirmPassword.enablePasswordToggle()
        self.txtFieldNewPassword.enablePasswordToggle()
        self.txtFieldNewPassword.delegate = self
        self.txtFieldConfirmPassword.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func chekValidation()-> Bool
    {
         if (self.txtFieldNewPassword.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter new password.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if self.txtFieldNewPassword.text?.count != 4
         {
             let alert = UIAlertController(title: webServices.AppName, message: "Please must be 4 character long.", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
             }))
             self.present(alert, animated: true, completion: nil)
             return false
         }
       else if (self.txtFieldConfirmPassword.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter confirm password.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if self.txtFieldNewPassword.text != self.txtFieldConfirmPassword.text
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Password and confirm password must be same.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }

        return true
    }
    
    
    @IBAction func tapSubmit(_ sender: Any) {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !self.chekValidation(){return}
        self.viewModel.updateNewPassword(token: self.token, newP: self.txtFieldNewPassword.text!, confrim: self.txtFieldConfirmPassword.text!, viewController: self, isLoaderRequired: true) { status, msg in
            if status == "Success"
            {
                let alert = UIAlertController(title: webServices.AppName, message: msg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popToRootViewController(animated: true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        self.txtFieldNewPassword.resignFirstResponder()
        self.txtFieldConfirmPassword.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtFieldNewPassword || textField == self.txtFieldConfirmPassword
        {
            let rawString = string
                 let range = rawString.rangeOfCharacter(from: .whitespaces)
                if ((textField.text?.count)! == 0 && range  != nil)
                || ((textField.text?.count)! > 0 && textField.text?.last  == " " && range != nil)  {
                    return false
                }
        }
        if textField == self.txtFieldNewPassword || textField == self.txtFieldConfirmPassword
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
