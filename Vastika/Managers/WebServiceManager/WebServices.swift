//
//  WebServices.swift
//  HaulifiedBoard
//
//  Created by APTA on 07/07/17.
//  Copyright © 2017 LimitLess. All rights reserved.
//

import Foundation
class webServices{
     //139.59.1.185:8080/truckerList
     static var token = ""
     static var refereshToken = ""

     static var preToken = "Bearer "
     static var headers = ["authorization":"\(preToken)\(webServices.token)"]
    
    
/// Base Url
    static let productionUrlMysql = "http://52.66.155.48/portal/"
   // static let productionUrlMysql =   "https://suvastika.staging.zoneonedigital.com/"
    static var baseUrl = webServices.productionUrlMysql;

    static let AppName = "Su-Vastika"
/************************************** End of Main URLs *****************************************************/
    static let loginRequest = "api/consumer/signin";
    static let countryGet =  "api/country/list"
    static let stateGet =  "api/state/list"
    static let cityGet =  "api/city/list"
    static let register = "api/consumer/register"
    static let forgotPassword = "api/consumer/forgot-password"
    static let verifyAccount = "api/consumer/verification-account"
    static let deviceList = "api/consumer/device/list"
    static let changePassword = "api/consumer/change-password"
    static let deviceDetails = "api/consumer/device/detail/"
    static let deleteDevice = "api/consumer/device/delete/"
    static let addDevicec = "api/consumer/device/add"
    static let deviceAlert = "api/consumer/device/alertlog/"
    static let logout = "api/consumer/logout"
    static let feedback = "api/consumer/feedback/add"
    static let resendOtP = "api/consumer/verification-resent-otp"
    static let mobileLoginOTp = "api/consumer/login-by-phone"
    static let veriFyMobOtp = "api/consumer/login-otp-verified"
    static let updateProfile = "api/consumer/profile-update"
    static let deviceControl = "api/consumer/setting/priority/"
    static let updatedSettingValue = "api/consumer/setting/"
    static let forgotPasswordVerifyOTP = "api/consumer/reset-password-link-check"
    static let forgotPasswordResendOTP = "api/consumer/reset-password-resent-otp"
    static let newPassword = "api/consumer/reset-password"
    static let updatedRegister = "api/consumer/signup"
    static let updateEmailAndMobil = "api/consumer/email-or-mobile-update-otp"
    static let verifyProfileOTP = "api/consumer/email-or-mobile-update-otp-verify"

    class var sharedInstance:webServices{
        struct sharedInstanceStruct{
            static let instance = webServices()
        }
        return sharedInstanceStruct.instance
    }
}
