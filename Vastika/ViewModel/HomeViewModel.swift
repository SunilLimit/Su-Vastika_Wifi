//
//  HomeViewModel.swift
//  Vastika
//
//  Created by Mac on 15/09/21.
//

import Foundation
import UIKit
import SwiftyJSON

class HomeViewModel: NSObject{
    
    var isEerror : Bool!
    var message : String!
    var listDevice : [HomeModel]!
    var listAlert : [AlertModel]!

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
        listDevice = [HomeModel]()
        let modelArray = json["data"].arrayValue
        for modelJson in modelArray{
            let value = HomeModel(fromJson: modelJson)
            listDevice.append(value)
        }
        
        listAlert = [AlertModel]()
        let modelAlertArray = json["data"].arrayValue
        for modelJson in modelAlertArray{
            let value = AlertModel(fromJson: modelJson)
            listAlert.append(value)
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
           if listDevice != nil{
            var dictionaryElements = [[String:Any]]()
            for modelElement in listDevice {
                dictionaryElements.append(modelElement.toDictionary())
            }
            dictionary["data"] = dictionaryElements
            }
        
            if listAlert != nil{
             var dictionaryAlertElements = [[String:Any]]()
             for modelElement in listAlert {
                dictionaryAlertElements.append(modelElement.toDictionary())
             }
             dictionary["data"] = dictionaryAlertElements
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
            listDevice = (aDecoder.decodeObject(forKey: "listDevice") as? [HomeModel])!
            listAlert = (aDecoder.decodeObject(forKey: "listAlert") as? [AlertModel])!
        
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
           if listDevice != nil{
               aCoder.encode(listDevice, forKey: "listDevice")
           }
            if listAlert != nil{
                aCoder.encode(listAlert, forKey: "listAlert")
            }
       }
    
    func getProductList(page:String,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:[HomeModel]) -> Void) {
        
        let requestP = webServices.deviceList + "?page=1"
        
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        webServices.headers = ["authorization":"\("bearer")\(webServices.token)"]

        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param:[:], serviceType: "get", header: webServices.headers, withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if output["errorMessage"].stringValue == "Token Expire and app going to logout."
            {
                completion(output["errorMessage"].stringValue, [HomeModel]())
            }
            
           else if output["errorMessage"].stringValue == "Unable to connect to server. Please try again after some time."
            {
                completion(output["errorMessage"].stringValue, [HomeModel]())
            }
            else if(output["isError"].boolValue == false){
                let items : HomeViewModel = HomeViewModel(fromjson: output["data"])
                let newItemlist : [HomeModel] = items.listDevice
                
                completion("Success", newItemlist)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,[HomeModel]())
            }

        }
    }
    
    func deleteDevice(deviceId:String,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String) -> Void) {
        
        let requestP = webServices.deleteDevice + deviceId
        
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        webServices.headers = ["authorization":"\("bearer")\(webServices.token)"]

        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param:[:], serviceType: "delete", header: webServices.headers, withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                completion("Success", output["message"].stringValue)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue)
            }

        }
    }
    
    func addDevice(srialNumber:String,deviceName : String,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String) -> Void) {
        
        let requestP = webServices.addDevicec
        let paramT = ["device_name" : deviceName,"serial_number" : srialNumber]
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        webServices.headers = ["authorization":"\("bearer")\(webServices.token)"]

        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param:paramT as! [String : AnyObject], serviceType: "post", header: webServices.headers, withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                completion("Success", output["message"].stringValue)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue)
            }

        }
    }
    
    
    
    func getDeviceAlert(deviceId : String, viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:[AlertModel]) -> Void) {
        
        let requestP = webServices.deviceAlert + deviceId
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        webServices.headers = ["authorization":"\("bearer")\(webServices.token)"]

        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param:[:], serviceType: "get", header: webServices.headers, withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                let items : HomeViewModel = HomeViewModel(fromjson: output)
                let newItemlist : [AlertModel] = items.listAlert
                completion("Success", newItemlist)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,[AlertModel]())
            }

        }
    }
    
    
    func updateNewPassword(token : String, newP : String, confrim : String,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String) -> Void) {
        
        
        let requestP = webServices.newPassword
        let paramT = ["token" : token,"new_password" : newP, "confirm_password" : confrim] as? NSDictionary
    
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param:paramT! as! [String : AnyObject], serviceType: "post", header: [:], withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
              
                
                completion("Success", output["message"].stringValue)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue)
            }

        }
        
    }
    
    
    
    func changePassword(old:String,newP : String, confrim : String,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String) -> Void) {
        
        
        let requestP = webServices.changePassword
        let paramT = ["old_password" : old,"new_password" : newP, "confirm_password" : confrim] as? NSDictionary
    
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        webServices.headers = ["authorization":"\("bearer")\(webServices.token)"]

        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param:paramT! as! [String : AnyObject], serviceType: "post", header: webServices.headers, withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
              
                
                completion("Success", output["message"].stringValue)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue)
            }

        }
        
    }
    
    
    func logout(viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String) -> Void) {
        
        
        let requestP = webServices.logout
        
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        webServices.headers = ["authorization":"\("bearer")\(webServices.token)"]

        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param:[:], serviceType: "post", header: webServices.headers, withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                completion("Success", output["message"].stringValue)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue)
            }

        }
    }
    
    func submitFeedback(deviceId:String,title : String, message : String,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String) -> Void) {
        
        
        let requestP = webServices.feedback
        let paramT = ["device_id" : deviceId,"title" : title, "message" : message] as? NSDictionary
    
        
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        webServices.headers = ["authorization":"\("bearer")\(webServices.token)"]

        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param:paramT! as! [String : AnyObject], serviceType: "post", header: webServices.headers, withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                completion("Success", output["message"].stringValue)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue)
            }

        }
    }
    
    
}
