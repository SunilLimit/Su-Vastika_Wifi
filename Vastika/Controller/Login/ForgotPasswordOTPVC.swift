//
//  ForgotPasswordOTPVC.swift
//  Vastika
//
//  Created by Sanjeev on 08/06/22.
//

import UIKit

class ForgotPasswordOTPVC: UIViewController {
   
    
    
    @IBOutlet weak var headingTitleLbl: UILabel!
    @IBOutlet weak var verifyOtpBtn: UIButton!
    @IBOutlet weak var otpView: VPMOTPView!
    @IBOutlet weak var resendOtpBtn: UIButton!
    @IBOutlet weak var resendLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var lblMsg: UILabel!
    var viewModel = RegisterViewModel()
    var isOtpEntered:Bool = false
    var enteredOtp:String = ""
    var isOTPVerfiyType = "phone"
    var email:String = ""
    var resendTime = 30
    var dictResponce = NSDictionary()
    var verifyKey = String()
    @IBOutlet weak var titleLbl: UILabel!
    var otpResendTime = 3
    @IBOutlet weak var innerView: UIView!
    private var timer:Timer?
    var isFrom = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setStatusBar(backgroundColor:Device.common_header_Color)
        self.resendLbl.isHidden = false
        // Do any additional setup after loading the view.
        print("type:- \(isOTPVerfiyType)")
        self.setupOtpView();
        self.verifyOtpBtn.layer.cornerRadius = 10.0
        self.verifyOtpBtn.clipsToBounds = true;
        
        self.innerView.layer.cornerRadius = 10.0
        self.innerView.clipsToBounds = true;
        if self.isFrom == "mob"
        {
            self.lblMsg.text = "Please type the verification code which sent to your Mobile Number or Email. \n In case of OTP is not recived , please check if you have entered the correct email ID or phone number while signing up."

        }
        else
        {
            self.lblMsg.text = "Please type the verification code which sent to your Mobile Number or Email. \n In case of OTP is not recived , please check if you have entered the correct email ID or phone number while signing up."
        }

    }

    
    func setupOtpView(){
       
        self.otpView.otpFieldBorderWidth = 1
        self.otpView.otpFieldsCount = 4;
        self.otpView.otpFieldSize = 50;
        self.otpView.otpFieldSeparatorSpace = 5
        self.otpView.delegate = self
        self.otpView.initializeUI();
        self.resetTimer()
    }
    
    
    func resetTimer(){
        self.resendOtpBtn.isEnabled = false
        self.resendTime = 30
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerValue), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimerValue(){
        self.resendLbl.text = "Resend in \(resendTime)s"
        if(resendTime == 0){
            self.timer?.invalidate()
            self.resendOtpBtn.isEnabled = true
            self.resendLbl.isHidden = true
            self.resendOtpBtn.isHidden = false
        }else{
            self.resendLbl.isHidden = false
            self.resendOtpBtn.isEnabled = false
            self.resendOtpBtn.isHidden = true
        }
        self.resendTime = self.resendTime > 0 ? self.resendTime - 1 : 30
    }
   
    @IBAction func verifyOtpBtnPressed(_ sender: UIButton) {
        if(self.isOtpEntered){
            //api call to verify otp
            self.verifyOTP();
        }else{
           
        }
    }
    
    @IBAction func tapResendOTP(_ sender: Any) {
        let param = ["token" : self.verifyKey]
   
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if self.isFrom == "mob"{
            self.viewModel.callResendOTPForForgot(deetails: param as NSDictionary, viewController: self, isLoaderRequired: true) { status, msg in
                if status == "Success"
                {
                    let alert = UIAlertController(title: webServices.AppName, message: msg, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.resetTimer()
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
        
    func verifyOTP(){
        
            if !Reachability.isConnectedToNetwork()
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
                let param = ["token" : self.verifyKey,"otp": self.enteredOtp]
                self.viewModel.verifyOTPForForgotPassword(deetails: param as NSDictionary, viewController: self, isLoaderRequired: true) { status, msg , token in
                    if status == "Success"
                    {
                        // move to update password
                        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "NewPasswordVC") as? NewPasswordVC{
                            vcToPresent.token = token
                            self.navigationController?.pushViewController(vcToPresent, animated: true)
                        }
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
    

    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}



extension ForgotPasswordOTPVC: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        self.isOtpEntered = hasEntered;
        return hasEntered
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        print("OTPString: \(otpString)")
        self.enteredOtp = otpString
    }
    
    
    
}
