//
//  Messages.swift
//  VMConsumer
//
//  Created by Developer on 25/10/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation


class Message{

    // MARK:- LOGIN SCREEN MESSAGES
    static let Email_pass_req = "Email and password are Required"
    static let Email_Req = "Email is Required."
     static let Email_Invalid = "Please enter valid email"
     static let password_Req = "Please Enter password"
    static let password_Min_DigitRequired = "Use 6 characters or more for your password."
    static let password_Min_DigitRequired_TF = "Minimum 6 characters required."
    
    static let default_ProcessingError = "Error in processing your request"
    // MARK:- Sign Up Screen Messages
    
    static let Name_req = "Please Enter Name.";
  //static let Email_req = "Please Enter Your Email Id.";
 // static let Password_req = "Set your account password.";
    static let ConfirmPassword_req = "Please Enter your password in Confirm Password Field.";
    static let ConfirmPassword_Match_req = "Password & Confirm Password not Matching.";
    static let Country_req = "Please Select Country";
    static let Country_min_digit_req = "Phone Number must have 10 digits.";
    static let ContactNumber_req = "Please enter your Phone Number."
    static let Invalid_contactNumber = "Invalid Contact Number. Please check your number."
    static let Dob_req = "Please Provide your date of Birth.";
    static let Dob_min_Validation = "Age must be greater than 10."
    static let Gender_req = "Please Select Gender."
    static let logoutMessage = "Are you sure you want to logout?"
    static let internet_ConnectionMsg = "The Internet connection appears to be offline.";
    
    static let same_AccountTransfer_alertMsg = "You cannot transfer money to your own wallet."

    static let camera = "Camera"
    static let phoneLibrary = "Phone Library"
   
    static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
    
    static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
    
    
    static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
    static let settingsBtnTitle = "Settings"
    static let cancelBtnTitle = "Cancel"
    
    
    static let emailIdNotVerified = "Your Mobile Number is not verified, please verify your Mobile Number before proceed."

// date comparision messages
    static let endDateNotLessThanStart = "To Date Cannot be less than From Date."
     static let startDateNotGreaterThanEnd = "From Date Cannot be greater than To Date."
    

    // message if server is not reachable
    static let server_unavailable = "Unable to connect to server. Please try again after some time."
    static let token_Expire = "Token Expire and app going to logout."

   // successful login msg
    static let successful_login = "Successfully Registered, Please Login to Continue";
    
    
    //Recharge amount
    static let recharge_amount_Req = "Please enter amount to recharge your wallet.";
    static let max_rechargeLimit = "Max recharge limit for this month reached."
    
    //setdefault message confirmation
    static let success_defaultMessageSet = "Successfully set Default wallet."
    
    
    // message for successfull payment from wallet scan & pay
    static let success_scan_payMsg = "Amount has been deducted from your wallet."
    static let orderPaymentSuccess = "Payment has been succesful."

    //change password messages
    static let successfullyChangedPassword = "Password has been changed successfully.";
    static let enterOldPswd = "Please Enter your Old Password."
    
    static let enterNewPswd = "Please Enter your New Password."
    static let enterConfirmPswd = "Please Confirm your Password."
    static let confirmPswdDoNotMatch = "New password and Confirm password not match."
    static let maxLength = "Password should be max 15 character long."
    static let passwordContainer = "Password should be contain 1 Upper case letter, 1 lower case letter,1 special character and at least 1 numeric."

    //version
    static let criticalUpdateAvailable = "Update new version to continue."
    static let normalUpdateAvailable = "Update to the new version."
       
    
    //Message for Machine is not available
    static let machineNotAvalable = "Machine is not available. You cannot raise complaint for this Machine"
    
    //messages for adding wallets
    static let displayNameReq = "Please enter display name.";
    static let passcodeReq = "Please enter passcode."
    
    //
    static let appearError = "There appears to be some issue in processing your request at this moment. Please try again later."
    
    static func messageForRechargeSuccess(amount:String,walletName:String) -> String{
        
        return "Amount " + AppUtils.rupeeSymbol  + amount + " has been added to your \(walletName)."
    }
    
    static func messageForDefaultSet(walletName:String)-> String{
        return "Do you want to set " + walletName + " as your default wallet?";
    }
    
    static func messageForRemoveWallet(walletName:String) -> String{
        return "Are you sure your want to remove " + walletName + " wallet?";

    }
    
    static func messageForAddWallet(walletName:String) -> String{
        return "Successfully added " + walletName + " wallet";
        
    }
    
    static func messageForSuccessfullyUpdatingDefaultWallet(walletName:String) -> String{
        
        return walletName + " has been set as your default wallet."
    }
    
}
