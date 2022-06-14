//
//  SignUpVC.swift
//  Vastika
//
//  Created by Mac on 14/09/21.
//

import UIKit

class SignUpVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var scrlHeight: NSLayoutConstraint!
    @IBOutlet weak var scrlViewe: UIScrollView!
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldConfirmEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var txtFieldConfirmPass: UITextField!
    @IBOutlet weak var txtFieldCountry: UITextField!
    @IBOutlet weak var txtFIeldState: UITextField!
    @IBOutlet weak var txtFieldCity: UITextField!
    @IBOutlet weak var txtFieldMobile: UITextField!
    @IBOutlet weak var lblPrefix: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var bottomVie: UIView!
    var pickerView = UIPickerView()
    var toolBar = UIToolbar()
    var arrayOfCountry = [Country]()
    var arrayOfCity = [CityModel]()
    var arrayOfState = [StateModee]()
    
    var countryId : Int = 0
    var stateId : Int = 0
    var cityId : Int = 0
    var isFrom = String()
    var viewModel = RegisterViewModel()
    
    // MARK:- View Life Cycle  -----------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrlViewe.contentSize = CGSize(width: self.scrlViewe.frame.size.width, height: 20)
        self.scrlHeight.constant = 290
        self.btnSignUp.layer.cornerRadius = self.btnSignUp.frame.size.height/2
        self.btnSignUp.clipsToBounds = true
        self.setupDelegate()
        self.setUpPicker()
        self.callServiceForCountry()
        if self.isFrom == "Mob"
        {
            self.btnSkip.isHidden = false
            let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary//setValue(dict, forKey: "user")
            let mob = dict?.object(forKey: "mobile") as? String
            self.txtFieldMobile.text = mob!
            self.bottomVie.isHidden = true
            self.txtFieldMobile.isUserInteractionEnabled = false
            self.lblTitle.text = "Update Profile"
            self.btnSignUp.setTitle("Update", for: .normal)
        }
        else
        {
            self.bottomVie.isHidden = false
            self.btnSkip.isHidden = true
            self.lblTitle.text = "SIGN UP"
            self.btnSignUp.setTitle("SIGN UP", for: .normal)

        }
        
        
        
        // Do any additional setup after loading the view.
    }

    // MARK:- Setup Delegat ---------
    
    func setupDelegate()
    {
        self.txtFieldCity.delegate = self
        self.txtFieldCountry.delegate = self
        self.txtFIeldState.delegate = self
        self.txtFieldName.delegate = self
        self.txtFieldEmail.delegate = self
        self.txtFieldConfirmEmail.delegate = self
        self.txtFieldName.delegate = self
        self.txtFieldMobile.delegate = self
        self.txtFieldPassword.delegate = self
        self.txtFieldConfirmPass.delegate = self
    }
    
    // MARK:- Setup Picker ---------

    func setUpPicker()
    {
        pickerView.delegate = self
        pickerView.dataSource = self
               
        self.txtFieldCountry.inputView = pickerView
        self.txtFieldCity.inputView = pickerView
        self.txtFIeldState.inputView = pickerView

       toolBar.barStyle = UIBarStyle.default
       toolBar.isTranslucent = true
       toolBar.tintColor = UIColor.init(red: 103/255, green: 48/255, blue: 197/255, alpha: 1)
       toolBar.sizeToFit()
       
       let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
       
       let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
       
       let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
       
       toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
       toolBar.isUserInteractionEnabled = true
               
        self.txtFieldCountry.inputAccessoryView = toolBar
        self.txtFieldCity.inputAccessoryView = toolBar
        self.txtFIeldState.inputAccessoryView = toolBar

}
    
    @objc func donePicker() {
        self.txtFIeldState.resignFirstResponder()
        self.txtFieldCity.resignFirstResponder()
        self.txtFieldCountry.resignFirstResponder()

    }
            
    @objc func cancelPicker()
    {
        self.txtFIeldState.resignFirstResponder()
        self.txtFieldCity.resignFirstResponder()
        self.txtFieldCountry.resignFirstResponder()
    }
    
    // MARK:- Call Service for Country/State/City -----------
    
    func callServiceForCountry()
    {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.viewModel.getCountryDetails(viewController: self, isLoaderRequired: true) { status, obj in
            if status == "Success"
            {
                self.arrayOfCountry = obj
            }
        }
    }
    
    func callServiceForState()
    {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.viewModel.getStateDetails(countryid: self.countryId, viewController: self, isLoaderRequired: true) { status, obj in
            if status == "Success"
            {
                self.arrayOfState = obj
                self.pickerView.reloadAllComponents()
            }
        }
    }
    
    func callServiceForCity()
    {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.viewModel.getCityDetails(stateId: self.stateId, viewController: self, isLoaderRequired: true) { status, obj in
            if status == "Success"
            {
                self.arrayOfCity = obj
                self.pickerView.reloadAllComponents()
            }
        }
    }

    // MARK:- Set Validation on Fields ------------
    
    func checkValidation()-> Bool
    {
        if (self.txtFieldName.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter name.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
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
        else if (self.txtFieldConfirmEmail.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter confirm email-Id .", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        else if self.txtFieldEmail.text != self.txtFieldConfirmEmail.text
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Email and Confirm email address must be same.", preferredStyle: UIAlertController.Style.alert)
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
        
        else if (self.txtFieldConfirmPass.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter confirm password.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if self.txtFieldPassword.text != self.txtFieldConfirmPass.text
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Password and confirm password must be same.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if self.txtFieldPassword.text!.count < 8
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Password must be contain one small,one capital,one number and one special character. And also password must be contains 8 character long.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if !(self.txtFieldPassword.text?.isValidPassword())!
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Password must be contain one small,one capital,one number and one special character. And also password must be contains 8 character long.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if (self.txtFieldCountry.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please select country.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if (self.txtFIeldState.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please select state.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if (self.txtFieldCity.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please select city.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if (self.txtFieldMobile.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter mobile number.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        let str = self.txtFieldMobile.text!.prefix(1)
        if str == "0"
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Phone number will never be start from 0.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        if !self.isValidMobileNumber(PhoneNumber: self.txtFieldMobile.text!)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please enter valid mobile number.", preferredStyle: UIAlertController.Style.alert)
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
   
    
    //MARK:- UIAction Method -----------
    
    @IBAction func tapSkip(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapSignIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapSignup(_ sender: Any) {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !self.checkValidation(){return}
        
        let dict = ["name"  : self.txtFieldName.text!,
                    "email" : self.txtFieldEmail.text!,
                    "confirm_email" : self.txtFieldConfirmEmail.text!,
                    "password"      : self.txtFieldPassword.text!,
                    "confirm_password" : self.txtFieldConfirmPass.text!,
                    "country_id" : String(self.countryId),
                    "state_id" : String(self.stateId),
                    "city_id" : String(self.cityId),
                    "mobile_number" : self.txtFieldMobile.text!,
                    "mob_prefix" : self.lblPrefix.text!
                    ]
        
        self.viewModel.registerUser(deetails: dict as NSDictionary, viewController: self, isLoaderRequired: true) { status, obj , vrifyKey in
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
    
    func veerifyRgisterdEemail(key : String, msg : String)
    {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "VerifyOTPViewController") as? VerifyOTPViewController{
            vcToPresent.verifyKey = key
            self.navigationController?.pushViewController(vcToPresent, animated: true);
        }
        
      
    }
    
    //MARK:-  UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtFieldCity
        {
            self.pickerView.tag = 3
            if self.stateId != 0
            {
                self.callServiceForCity()
            }
        }
        if textField == self.txtFieldCountry
        {
            self.pickerView.tag = 1
            self.pickerView.reloadAllComponents()

        }
        if textField == self.txtFIeldState
        {
            self.pickerView.tag = 2
            if self.countryId != 0
            {
                self.callServiceForState()
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
        if self.txtFieldName == textField || self.txtFieldEmail == textField || self.txtFieldConfirmEmail == textField
        {
            let maxLength = 50
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if self.txtFieldMobile == textField
        {
            let maxLength = 10
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
        if self.pickerView.tag == 1
        {
            return self.arrayOfCountry.count
        }
        else if self.pickerView.tag == 2
        {
            return self.arrayOfState.count
        }
        else if self.pickerView.tag == 3
        {
            return self.arrayOfCity.count
        }
      return 0
     }
     
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          
        var value = String()
        if self.pickerView.tag == 1
        {
            value = self.arrayOfCountry[row].name
        }
        else if self.pickerView.tag == 2
        {
            value = self.arrayOfState[row].name
        }
        else if self.pickerView.tag == 3
        {
            value = self.arrayOfCity[row].name
        }
        return value
     }
     
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        var value = String()
        if self.pickerView.tag == 1
        {
            value = self.arrayOfCountry[row].name
            self.txtFieldCountry.text = value
            let id = self.arrayOfCountry[row].id
            let preFix = self.arrayOfCountry[row].mob_prefix
            self.lblPrefix.text = preFix
            self.countryId = id!
        }
        else if self.pickerView.tag == 2
        {
            value = self.arrayOfState[row].name
            self.txtFIeldState.text = value
            let id = self.arrayOfState[row].id
            self.stateId = id!
        }
        else if self.pickerView.tag == 3
        {
            value = self.arrayOfCity[row].name
            self.txtFieldCity.text = value
            let id = self.arrayOfCity[row].id
            self.cityId = id!
        }
        
     }
    
}
extension String {
    func isValidPassword() -> Bool {
        let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)

        return passwordValidation.evaluate(with: self)
    }
}
