//
//  ChangePasswordVC.swift
//  Vastika
//
//  Created by Mac on 15/09/21.
//

import UIKit

class ChangePasswordVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtFieldOldPassword: UITextField!
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!
    @IBOutlet weak var txtFieldNewPassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSubmit.layer.cornerRadius = self.btnSubmit.frame.size.height/2
        self.btnSubmit.clipsToBounds = true
        self.txtFieldOldPassword.enablePasswordToggle()
        self.txtFieldConfirmPassword.enablePasswordToggle()
        self.txtFieldNewPassword.enablePasswordToggle()
        self.txtFieldNewPassword.delegate = self
        self.txtFieldOldPassword.delegate = self
        self.txtFieldConfirmPassword.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.view?.resignFirstResponder()
        self.txtFieldOldPassword.resignFirstResponder()
        self.txtFieldNewPassword.resignFirstResponder()
        self.txtFieldConfirmPassword.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func chekValidation()-> Bool
    {
        if (self.txtFieldOldPassword.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter old password.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
       else if (self.txtFieldNewPassword.text?.isEmpty ?? true)
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
        self.txtFieldOldPassword.resignFirstResponder()
        self.txtFieldNewPassword.resignFirstResponder()
        self.txtFieldConfirmPassword.resignFirstResponder()
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !self.chekValidation(){return}
        self.viewModel.changePassword(old: self.txtFieldOldPassword.text!, newP: self.txtFieldNewPassword.text!, confrim: self.txtFieldConfirmPassword.text!, viewController: self, isLoaderRequired: true) { status, msg in
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
    

}
