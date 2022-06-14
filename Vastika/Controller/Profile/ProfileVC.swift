//
//  ProfileVC.swift
//  Vastika
//
//  Created by Mac on 15/09/21.
//

import UIKit

class ProfileVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    
    @IBOutlet weak var detailsViewe: UIView!
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var txtFiledState: UITextField!
    @IBOutlet weak var txtFiledCity: UITextField!
    @IBOutlet weak var txtFieldCountry: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMob: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtFieldDetails: UITextField!
    @IBOutlet weak var lblemailHeight: NSLayoutConstraint!
    @IBOutlet weak var btnemailHeight: NSLayoutConstraint!
    var pickerView = UIPickerView()
    var toolBar = UIToolbar()
    var arrayOfCountry = [Country]()
    var arrayOfCity = [CityModel]()
    var arrayOfState = [StateModee]()
    var viewModel = RegisterViewModel()
    var email = String()
    var mobile = String()
    var countryId : Int = 0
    var stateId : Int = 0
    var cityId : Int = 0
    var changeFrom = String()
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnMob: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setupDelegate()
        self.setUpPicker()
        self.detailsViewe.layer.cornerRadius = 5.0
        self.detailsViewe.layer.borderWidth = 1.0
        self.detailsViewe.layer.borderColor = UIColor.gray.cgColor
        self.detailsViewe.clipsToBounds = true
        
       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let name = dict?.object(forKey: "name") as? String
        let email = dict?.object(forKey: "email") as? String
        let mob = dict?.object(forKey: "mobile") as? String
        let preix = dict?.object(forKey: "mobilprefix") as? String
        let strDetails = "Name : " + name!
        self.countryId = (dict?.object(forKey: "countryId") as? Int)!
        self.stateId = (dict?.object(forKey: "stateId") as? Int)!
        self.cityId = (dict?.object(forKey: "cityId") as? Int)!
        self.lblDetails.text = strDetails
        let emailDetails = "Email : " + email!
        self.lblEmail.text = emailDetails
        let mobile = "Mobile Number : " + preix! + " " + mob!
        self.lblMob.text = mobile
        self.callServiceForCountry()
        self.callServiceForState()
        self.callServiceForCity()
        self.txtFieldName.text = name!
        self.email = email!
        self.mobile = mob!
        if (email!.isEmpty ?? true)
        {
            self.lblEmail.isHidden = true
            self.btnEmail.isHidden = true
            self.lblemailHeight.constant = 0
            self.btnemailHeight.constant = 0
        }
        else if (mob!.isEmpty ?? true)
        {
            self.lblMob.isHidden = true
            self.btnMob.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    
    @IBAction func tapClose(_ sender: Any) {
        self.alertView.isHidden = true
    }
    
  
    func setattributedText(str : String, setString : String) -> NSMutableAttributedString
    {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: str )
        attributedString.setColor(color: UIColor.init(red: 27.0/255.0, green: 77.0/255.0, blue: 130.0/255.0, alpha: 1.0), forText: setString)
        return attributedString
    }

    @IBAction func tapEditEmail(_ sender: Any) {
        self.alertView.isHidden = false
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
       
        let email = dict?.object(forKey: "email") as? String
       
        self.lblTitle.text = "Email"
        self.txtFieldDetails.delegate = self
        self.txtFieldDetails.placeholder = "Enter email Id"
        self.txtFieldDetails.text = email
        self.changeFrom = "email"
    }
    
    @IBAction func tapEditMob(_ sender: Any) {
        self.alertView.isHidden = false
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let mob = dict?.object(forKey: "mobile") as? String
        let mobile = mob!
        
        self.lblTitle.text = "Mobile"
        self.txtFieldDetails.delegate = self
        self.txtFieldDetails.placeholder = "Enter Mobile Number "
        self.txtFieldDetails.text = mobile
        self.changeFrom = "mob"

    }
    
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapUpdateDetails(_ sender: Any) {
        
        if self.changeFrom == "email"
        {
            if (self.txtFieldDetails.text?.isEmpty ?? true)
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Please enter email-Id .", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else if !self.isValidEmailId(emailId: self.txtFieldDetails.text!)
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Please enter valid email-Id .", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            // call service
            if !Reachability.isConnectedToNetwork()
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let dict = ["update_type"  : "email",
                        "email_or_mobile_number" : self.txtFieldDetails.text!
                        ]
            self.viewModel.updateMobileAndEmailNumber(deetails: dict as NSDictionary, viewController: self, isLoaderRequired: true) { errorString, obj, email in
                if errorString == "Success"
                {
                    self.alertView.isHidden = true
                    if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "VerifyProfileOTPVC") as? VerifyProfileOTPVC{
                        vcToPresent.email = self.txtFieldDetails.text!
                        vcToPresent.verifyKey = "email"
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
        else if self.changeFrom == "mob"
        {
            if (self.txtFieldDetails.text?.isEmpty ?? true)
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Please enter mobile number.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else if self.txtFieldDetails.text!.isNumeric
            {
                let mobCheck =  self.txtFieldDetails.text?.first
                if mobCheck == "0"
                {
                    let alert = UIAlertController(title: webServices.AppName, message: "Mobile number does not started with 0 .", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                       
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                else if !self.isValidMobileNumber(PhoneNumber: self.txtFieldDetails.text!)
                {
                    let alert = UIAlertController(title: webServices.AppName, message: "Please enter valid Mobile Number.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                       
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                // call service
                if !Reachability.isConnectedToNetwork()
                {
                    let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                       
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                let dict = ["update_type"  : "mobile",
                            "email_or_mobile_number" : self.txtFieldDetails.text!
                            ]
                self.viewModel.updateMobileAndEmailNumber(deetails: dict as NSDictionary, viewController: self, isLoaderRequired: true) { errorString, obj, email in
                    if errorString == "Success"
                    {
                        self.alertView.isHidden = true
                        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "VerifyProfileOTPVC") as? VerifyProfileOTPVC{
                            vcToPresent.email = self.txtFieldDetails.text!
                            vcToPresent.verifyKey = "mobile"
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
        }
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
    
    
    
    @IBAction func tapSubmit(_ sender: Any) {
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
                    "email" : self.email,
                    "confirm_email" : self.email,
                    "password"      : "",
                    "confirm_password" : "",
                    "country_id" : String(self.countryId),
                    "state_id" : String(self.stateId),
                    "city_id" : String(self.cityId),
                    "mobile_number" : self.mobile,
                    "mob_prefix" : "+91"
                    ]
        self.viewModel.updateProfile(deetails: dict as NSDictionary, viewController: self, isLoaderRequired: true) { errorString, obj, email in
            if errorString == "Success"
            {
                let alert = UIAlertController(title: webServices.AppName, message: obj, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
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
    
    // MARK:- Setup Delegat ---------
    
    func setupDelegate()
    {
        self.txtFiledCity.delegate = self
        self.txtFieldCountry.delegate = self
        self.txtFiledState.delegate = self
        self.txtFieldName.delegate = self
       
    }
    
    // MARK:- Setup Picker ---------

    func setUpPicker()
    {
        pickerView.delegate = self
        pickerView.dataSource = self
               
        self.txtFieldCountry.inputView = pickerView
        self.txtFiledCity.inputView = pickerView
        self.txtFiledState.inputView = pickerView

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
        self.txtFiledCity.inputAccessoryView = toolBar
        self.txtFiledState.inputAccessoryView = toolBar

}
    
    @objc func donePicker() {
        self.txtFiledState.resignFirstResponder()
        self.txtFiledCity.resignFirstResponder()
        self.txtFieldCountry.resignFirstResponder()

    }
            
    @objc func cancelPicker()
    {
        self.txtFiledState.resignFirstResponder()
        self.txtFiledCity.resignFirstResponder()
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
                
                if self.countryId != 0
                {
                    for country in self.arrayOfCountry
                    {
                        if self.countryId == country.id
                        {
                            self.txtFieldCountry.text = country.name
                        }
                    }
                }
                
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
                if self.stateId != 0
                {
                    for state in self.arrayOfState
                    {
                        if self.stateId == state.id
                        {
                            self.txtFiledState.text = state.name
                        }
                    }
                }
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
                if self.cityId != 0
                {
                    for city in self.arrayOfCity
                    {
                        if self.cityId == city.id
                        {
                            self.txtFiledCity.text = city.name
                        }
                    }
                }
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
        else if (self.txtFieldCountry.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please select country.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if (self.txtFiledState.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please select state.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if (self.txtFiledCity.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Please select city.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    //MARK:-  UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtFiledCity
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
        if textField == self.txtFiledState
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
        if self.txtFieldName == textField
        {
            let maxLength = 30
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if self.changeFrom == "email"
        {
            let maxLength = 30
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if self.changeFrom == "mob"
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
            self.countryId = id!
            self.txtFiledState.text = ""
            self.txtFiledCity.text = ""
        }
        else if self.pickerView.tag == 2
        {
            value = self.arrayOfState[row].name
            self.txtFiledState.text = value
            let id = self.arrayOfState[row].id
            self.stateId = id!
            self.txtFiledCity.text = ""
        }
        else if self.pickerView.tag == 3
        {
            value = self.arrayOfCity[row].name
            self.txtFiledCity.text = value
            let id = self.arrayOfCity[row].id
            self.cityId = id!
        }
        
     }
    
}
