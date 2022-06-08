//
//  HomeModel.swift
//  Vastika
//
//  Created by Mac on 15/09/21.
//

import Foundation
import SwiftyJSON

class HomeModel:NSObject,Codable{

    var device_id : Int!
    var image_path : String!
    var added_on : String!
    var device_name : String!
    var device_type : String!
    var serial_number : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        device_id = json["device_id"].intValue
        image_path = json["image_path"].stringValue
        added_on = json["added_on"].stringValue
        device_name = json["device_name"].stringValue
        device_type = json["device_type"].stringValue
        serial_number = json["image_path"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if device_id != nil{
            dictionary["device_id"] = device_id
        }
       
        if image_path != nil{
            dictionary["image_path"] = image_path
        }
        if added_on != nil{
            dictionary["code"] = added_on
        }
        if device_name != nil{
            dictionary["device_name"] = device_name
        }
        if device_type != nil{
            dictionary["device_type"] = device_type
        }
        if serial_number != nil{
            dictionary["serial_number"] = serial_number
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        device_id = aDecoder.decodeObject(forKey: "device_id") as? Int
        image_path = aDecoder.decodeObject(forKey: "image_path") as? String
        added_on = (aDecoder.decodeObject(forKey: "added_on") as? String)!
        device_name = (aDecoder.decodeObject(forKey: "device_name") as? String)!
        device_type = (aDecoder.decodeObject(forKey: "device_type") as? String)!
        serial_number = (aDecoder.decodeObject(forKey: "serial_number") as? String)!

        
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if device_id != nil{
            aCoder.encode(device_id, forKey: "device_id")
        }
       
        if image_path != nil{
            aCoder.encode(image_path, forKey: "image_path")
        }
        if added_on != nil{
            aCoder.encode(added_on, forKey: "added_on")
        }
        if device_name != nil{
            aCoder.encode(device_name, forKey: "device_name")
        }
        if device_type != nil{
            aCoder.encode(device_type, forKey: "device_type")
        }
        if serial_number != nil{
            aCoder.encode(serial_number, forKey: "serial_number")
        }
    }
}



