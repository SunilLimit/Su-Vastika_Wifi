//
//  LoginViewModel.swift
//  Vastika
//
//  Created by Mac on 14/09/21.
//

import Foundation
import UIKit
import SwiftyJSON

class loginViewModel{
    
    //for login
    func RequestLogin(email:String, password : String ,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String) -> Void) {
        
        let requestP = webServices.loginRequest
        let paramT = ["mobile_or_email" : email,"password" : password]
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: paramT as [String : AnyObject], serviceType: "post", header: [:], withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                let email = output["data"]["email"].stringValue
                let countryId = output["data"]["country_id"].intValue
                let cityId = output["data"]["city_id"].intValue
                let stateId = output["data"]["state_id"].intValue
                let mobile = output["data"]["mobile_number"].stringValue
                let mobilePrefix = output["data"]["mob_prefix"].stringValue
                let loginDate = output["data"]["last_logedin_date"].stringValue
                let name = output["data"]["name"].stringValue
                let token = output["data"]["token"].stringValue
                let tokenType = output["data"]["token_type"].stringValue
                webServices.token = token
                let dict = ["email":email,"countryId" : countryId,"cityId" : cityId,"stateId" : stateId,"mobile":mobile,"mobilprefix" : mobilePrefix,"date" : loginDate,"name" : name,"token" : token,"tokeenPrexfix" : tokenType] as [String : Any]
                UserDefaults.standard.setValue(true, forKey: "isLogin")
                UserDefaults.standard.setValue(dict, forKey: "user")
                UserDefaults.standard.synchronize()
                completion("Success", output["message"].stringValue)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue);
            }

        }
    }
    
    func reequestForPassword(email:String ,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String, _ key : String) -> Void) {
        
        let requestP = webServices.forgotPassword
        let paramT = ["email" : email]
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: paramT as [String : AnyObject], serviceType: "post", header: [:], withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                completion("Success", output["message"].stringValue,output["data"]["token"].stringValue)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue,"");
            }

        }
    }
    
    
    func reequestMobileLoginOTP(mob:String ,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String,_ key : String) -> Void) {
        
        let requestP = webServices.mobileLoginOTp
        let paramT = ["mobile_number" : mob,"mob_prefix" : "+91"]
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: paramT as [String : AnyObject], serviceType: "post", header: [:], withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                completion("Success", output["message"].stringValue,output["data"]["otp_verification_key"].stringValue)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue,"");
            }

        }
    }
}
