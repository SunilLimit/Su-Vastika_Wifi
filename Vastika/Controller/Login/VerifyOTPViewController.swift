//
//  VerifyOTPViewController.swift
//  GobblyWS
//
//  Created by Akash - iOS Dev on 12/07/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class VerifyOTPViewController: UIViewController {

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
            self.lblMsg.text = "Please type the verification code which sent to your Mobile Number. \n In case of OTP is not recived , please check if you have entered the correct email ID or phone number while signing up."

        }
        else
        {
            self.lblMsg.text = "Please type the verification code which sent to your Email. \n In case of OTP is not recived , please check if you have entered the correct email ID or phone number while signing up."
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
        let param = ["email_verification_key" : self.verifyKey]
        if(isOTPVerfiyType=="phone"){
            if !Reachability.isConnectedToNetwork()
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if self.isFrom == "mob"{
                self.viewModel.callResendOTP(deetails: param as NSDictionary, viewController: self, isLoaderRequired: true) { status, msg in
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
            else
            {
                self.viewModel.callResendOTP(deetails: param as NSDictionary, viewController: self, isLoaderRequired: true) { status, msg in
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
    }
    
    
    func verifyOTP(){
        
        if(isOTPVerfiyType=="phone"){
            if !Reachability.isConnectedToNetwork()
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if self.isFrom == "mob"{
                let param = ["otp_verification_key" : self.verifyKey,"otp": self.enteredOtp]
                self.viewModel.registerUserVerifyMob(deetails: param as NSDictionary, viewController: self, isLoaderRequired: true) { status, msg , email in
                    if status == "Success"
                    {
                        if email == "" || email.count == 0{
                            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "UpdateProfileVC") as? UpdateProfileVC{
                                vcToPresent.isFrom = "Mob"
                                self.navigationController?.pushViewController(vcToPresent, animated: true);
                            }
                        }
                        else
                        {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.setHomeVieew()
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
            else
            {
                let param = ["email_verification_key" : self.verifyKey,"otp": self.enteredOtp]
                self.viewModel.registerUserVerifyEmail(deetails: param as NSDictionary, viewController: self, isLoaderRequired: true) { status, msg in
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
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }

        }
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension VerifyOTPViewController: VPMOTPViewDelegate {
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
