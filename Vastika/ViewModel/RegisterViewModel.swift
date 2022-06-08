//
//  RegisterViewModel.swift
//  Vastika
//
//  Created by Mac on 15/09/21.
//

import Foundation
import UIKit
import SwiftyJSON

class RegisterViewModel: NSObject{
    
    var isEerror : Bool!
    var message : String!
    var listCountry : [Country]!
    var listState : [StateModee]!
    var listCity : [CityModel]!

    override init() {
        super.init()
    }
    
    init(fromjson json : JSON!)
    {
        if json.isEmpty
        {
            return
        }
        message = json["message"].stringValue
        isEerror = json["isEerror"].boolValue
        listCountry = [Country]()
        let modelArray = json["data"].arrayValue
        for modelJson in modelArray{
            let value = Country(fromJson: modelJson)
            listCountry.append(value)
        }
        
        listState = [StateModee]()
        let modelStateArray = json["data"].arrayValue
        for modelJson in modelStateArray{
            let value = StateModee(fromJson: modelJson)
            listState.append(value)
        }
        
        listCity = [CityModel]()
        let modelcityArray = json["data"].arrayValue
        for modelJson in modelcityArray{
            let value = CityModel(fromJson: modelJson)
            listCity.append(value)
        }
    }
    
    /**
        * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
        */
       func toDictionary() -> [String:Any]
       {
          var dictionary = [String:Any]()
           if isEerror != nil{
               dictionary["isEerror"] = isEerror
           }
           
           if message != nil{
               dictionary["message"] = message
           }
           if listCountry != nil{
            var dictionaryElements = [[String:Any]]()
            for modelElement in listCountry {
                dictionaryElements.append(modelElement.toDictionary())
            }
            dictionary["data"] = dictionaryElements
            }
        
        if listState != nil{
         var dictionaryElements = [[String:Any]]()
         for modelElement in listState {
             dictionaryElements.append(modelElement.toDictionary())
         }
         dictionary["data"] = dictionaryElements
         }
        
        if listCity != nil{
         var dictionaryElements = [[String:Any]]()
         for modelElement in listCity {
             dictionaryElements.append(modelElement.toDictionary())
         }
         dictionary["data"] = dictionaryElements
         }
        
            return dictionary
        
       }
    
    /**
       * NSCoding required initializer.
       * Fills the data from the passed decoder
       */
       @objc required init(coder aDecoder: NSCoder)
       {
            isEerror = aDecoder.decodeObject(forKey: "isEerror") as? Bool
            message = aDecoder.decodeObject(forKey: "message") as? String
            listCountry = (aDecoder.decodeObject(forKey: "listCountry") as? [Country])!
            listState = (aDecoder.decodeObject(forKey: "listState") as? [StateModee])!
            listCity = (aDecoder.decodeObject(forKey: "listCity") as? [CityModel])!

       }
    
    /**
       * NSCoding required method.
       * Encodes mode properties into the decoder
       */
       func encode(with aCoder: NSCoder)
       {
          if isEerror != nil{
               aCoder.encode(isEerror, forKey: "isEerror")
           }
           if message != nil{
               aCoder.encode(message, forKey: "message")
           }
           if listCountry != nil{
               aCoder.encode(listCountry, forKey: "listCountry")
           }
            if listState != nil{
                aCoder.encode(listState, forKey: "listState")
            }
            if listCity != nil{
                aCoder.encode(listCity, forKey: "listCity")
            }
       }
    
    
    //for login
    func getCountryDetails(viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:[Country]) -> Void) {
        
        let requestP = webServices.countryGet
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: [:], serviceType: "get", header: [:], withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                let items : RegisterViewModel = RegisterViewModel(fromjson: output)
                let newItemlist : [Country] = items.listCountry
                
                completion("Success", newItemlist)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,[Country]());
            }

        }
    }
    
    func getStateDetails(countryid : Int, viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:[StateModee]) -> Void) {
        
        let requestP = webServices.stateGet + "?country_id=" + String(countryid)
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: [:], serviceType: "get", header: [:], withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                let items : RegisterViewModel = RegisterViewModel(fromjson: output)
                let newItemlist : [StateModee] = items.listState
                completion("Success", newItemlist)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,[StateModee]());
            }

        }
    }
    
    func getCityDetails(stateId : Int, viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:[CityModel]) -> Void) {
        
        let requestP = webServices.cityGet + "?state_id=" + String(stateId)
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: [:], serviceType: "get", header: [:], withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                let items : RegisterViewModel = RegisterViewModel(fromjson: output)
                let newItemlist : [CityModel] = items.listCity
                completion("Success", newItemlist)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,[CityModel]());
            }

        }
    }
    
    func registerUser(deetails : NSDictionary ,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String, _ emailVeerifyKey : String) -> Void) {
        
        let requestP = webServices.register
        let paramT = deetails
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: paramT as! [String : AnyObject], serviceType: "post", header: [:], withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                let key = output["data"]["email_verification_key"].string
                
                completion("Success", output["message"].stringValue, key!)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue,"");
            }

        }
    }
    
    func registerUpdatedUser(deetails : NSDictionary ,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String, _ emailVeerifyKey : String) -> Void) {
        
        let requestP = webServices.updatedRegister
        let paramT = deetails
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: paramT as! [String : AnyObject], serviceType: "post", header: [:], withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                let key = output["data"]["email_verification_key"].string
                
                completion("Success", output["message"].stringValue, key!)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue,"");
            }

        }
    }
    
    func registerUserVerifyEmail(deetails : NSDictionary ,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String) -> Void) {
        
        let requestP = webServices.verifyAccount
        let paramT = deetails
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: paramT as! [String : AnyObject], serviceType: "post", header: [:], withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                completion("Success", output["message"].stringValue)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue);
            }

        }
    }
    
    func registerUserVerifyMob(deetails : NSDictionary ,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String, _ email : String) -> Void) {
        
        let requestP = webServices.veriFyMobOtp
        let paramT = deetails
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: paramT as! [String : AnyObject], serviceType: "post", header: [:], withVC: viewController) { (res) in

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
                completion("Success", output["message"].stringValue,email)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue,"");
            }

        }
    }
    
    func verifyOTPForForgotPassword(deetails : NSDictionary ,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String, _ email : String) -> Void) {
        
        let requestP = webServices.forgotPasswordVerifyOTP
        let paramT = deetails
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: paramT as! [String : AnyObject], serviceType: "post", header: [:], withVC: viewController) { (res) in

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
    
    func updateProfile(deetails : NSDictionary ,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String, _ email : String) -> Void) {
        
        let requestP = webServices.updateProfile
        let paramT = deetails
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        webServices.headers = ["authorization":"\("bearer")\(webServices.token)"]
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: paramT as! [String : AnyObject], serviceType: "post", header: webServices.headers, withVC: viewController) { (res) in

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
                var token = output["data"]["token"].stringValue
                let tokenType = output["data"]["token_type"].stringValue
                if token.count == 0
                {
                    let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
                    token = (dict?.object(forKey: "token") as? String)!
                }
                
                webServices.token = token
                let dict = ["email":email,"countryId" : countryId,"cityId" : cityId,"stateId" : stateId,"mobile":mobile,"mobilprefix" : mobilePrefix,"date" : loginDate,"name" : name,"token" : token,"tokeenPrexfix" : tokenType] as [String : Any]
                UserDefaults.standard.setValue(true, forKey: "isLogin")
                UserDefaults.standard.setValue(dict, forKey: "user")
                UserDefaults.standard.synchronize()
                completion("Success", output["message"].stringValue,email)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue,"");
            }

        }
    }
    
    
    
    func updateMobileAndEmailNumber(deetails : NSDictionary ,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String, _ email : String) -> Void) {
        
        let requestP = webServices.updateEmailAndMobil
        let paramT = deetails
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        webServices.headers = ["authorization":"\("bearer")\(webServices.token)"]
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: paramT as! [String : AnyObject], serviceType: "post", header: webServices.headers, withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                completion("Success", output["message"].stringValue,"")
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue,"");
            }

        }
    }
    
    
    
    func callResendOTP(deetails : NSDictionary ,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String) -> Void) {
        
        let requestP = webServices.resendOtP
        let paramT = deetails
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: paramT as! [String : AnyObject], serviceType: "post", header: [:], withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                completion("Success", output["message"].stringValue)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue);
            }

        }
    }
    
    func callResendOTPForForgot(deetails : NSDictionary ,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String) -> Void) {
        
        let requestP = webServices.forgotPasswordResendOTP
        let paramT = deetails
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: paramT as! [String : AnyObject], serviceType: "post", header: [:], withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                completion("Success", output["message"].stringValue)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue);
            }

        }
    }
    
}

