//
//  AlertModel.swift
//  Vastika
//
//  Created by Mac on 22/09/21.
//

import Foundation
import SwiftyJSON

class AlertModel:NSObject,Codable{

    var status_error : String!
    var log_date : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        status_error = json["status_error"].stringValue
        log_date = json["log_date"].stringValue

    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
       
        if status_error != nil{
            dictionary["status_error"] = status_error
        }
        if log_date != nil{
            dictionary["log_date"] = log_date
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        status_error = aDecoder.decodeObject(forKey: "status_error") as? String
        log_date = (aDecoder.decodeObject(forKey: "log_date") as? String)!
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
       
        if status_error != nil{
            aCoder.encode(status_error, forKey: "status_error")
        }
        if log_date != nil{
            aCoder.encode(log_date, forKey: "log_date")
        }
    }
}


