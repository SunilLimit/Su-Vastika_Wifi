//
//  DeviceDetailsViewModel.swift
//  Vastika
//
//  Created by Mac on 17/09/21.
//

import Foundation
import UIKit
import SwiftyJSON

class DeviceDetailsViewModel : NSObject{
    
    var isEerror : Bool!
    var message : String!
    var deviceRecord : DeviceDetailsModel!
    var currencyList : [currencyModel]!

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
        deviceRecord = DeviceDetailsModel(fromJson: json["data"])
        
        currencyList = [currencyModel]()
        let modelArray = json["data"].arrayValue
        for modelJson in modelArray{
            let value = currencyModel(fromJson: modelJson)
            currencyList.append(value)
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
        if deviceRecord != nil{
            dictionary["deviceRecord"] = deviceRecord
        }
           
           if currencyList != nil{
            var dictionaryElements = [[String:Any]]()
            for modelElement in currencyList {
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
            deviceRecord = aDecoder.decodeObject(forKey: "deviceRecord") as? DeviceDetailsModel
           currencyList = aDecoder.decodeObject(forKey: "currencyList") as? [currencyModel]

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
        if deviceRecord != nil{
            aCoder.encode(deviceRecord, forKey: "deviceRecord")
        }
           if currencyList != nil{
               aCoder.encode(currencyList, forKey: "currencyList")
           }
       }

    func deviceDetails(deviceId:String,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:DeviceDetailsModel) -> Void) {
        
        let requestP = webServices.deviceDetails + deviceId
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        webServices.headers = ["authorization":"\("bearer")\(webServices.token)"]
        
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: [:], serviceType: "get", header: webServices.headers, withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if output["errorMessage"].stringValue == "Unable to connect to server. Please try again after some time."
            {
                completion(output["errorMessage"].stringValue, (DeviceDetailsViewModel(fromjson: output).deviceRecord))
            }
            else if(output["isError"].boolValue == false){
                let model : DeviceDetailsViewModel = DeviceDetailsViewModel(fromjson: output)
                self.deviceRecord = model.deviceRecord
                completion("Success", model.deviceRecord)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,(DeviceDetailsViewModel(fromjson: output).deviceRecord));
            }

        }
    }
    
    func updateSettingValues(deviceId:String,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String) -> Void) {
        
        let requestP = webServices.updatedSettingValue + deviceId
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        webServices.headers = ["authorization":"\("bearer")\(webServices.token)"]
        
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: [:], serviceType: "get", header: webServices.headers, withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                let model : DeviceDetailsViewModel = DeviceDetailsViewModel(fromjson: output)
                self.deviceRecord = model.deviceRecord
                completion("Success", output["message"].stringValue)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue);
            }

        }
    }
    
    
    func getCurrencyDetails(viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:[currencyModel]) -> Void) {
        
        let requestP = webServices.currenyDetails
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        webServices.headers = ["authorization":"\("bearer")\(webServices.token)"]
        
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: [:], serviceType: "get", header: webServices.headers, withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                let model : DeviceDetailsViewModel = DeviceDetailsViewModel(fromjson: output)
                completion("Success", model.currencyList)
            }else{
                print("error completion called");
                let model : DeviceDetailsViewModel = DeviceDetailsViewModel(fromjson: output)
                completion(output["errorMessage"].stringValue,model.currencyList);
            }

        }
    }
    
    
    func updateCurency(charge : String, currency : String, deviceId : String,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String) -> Void) {
        
       
        let requestP = webServices.upadteCurrency + deviceId + "/echarges"
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        webServices.headers = ["authorization":"\("bearer")\(webServices.token)"]
        
        let dcit = ["electricity_unit_charge" : charge,"currency" : currency] as? [String : AnyObject]
        
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: dcit!, serviceType: "post", header: webServices.headers, withVC: viewController) { (res) in

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
    
    
    func deviceOnoff(deviceId:String,control : Int,viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ obj:String) -> Void) {
        
        let requestP = webServices.deviceControl + deviceId + "/" + "\(control)"
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        webServices.headers = ["authorization":"\("bearer")\(webServices.token)"]
        
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: [:], serviceType: "get", header: webServices.headers, withVC: viewController) { (res) in

            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }

            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                let model : DeviceDetailsViewModel = DeviceDetailsViewModel(fromjson: output)
                self.deviceRecord = model.deviceRecord
                completion("Success", output["message"].stringValue)
            }else{
                print("error completion called");
                completion(output["errorMessage"].stringValue,output["message"].stringValue);
            }

        }
    }
    
    
    
}
