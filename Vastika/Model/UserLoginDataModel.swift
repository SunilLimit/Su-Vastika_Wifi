//
//  UserLoginDataModel.swift
//  VMConsumer
//
//  Created by Developer on 14/12/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserLoginDataModel:NSObject,Codable{
    

    
    var id : Int!
    var image : String = ""
    var updated_at : String!
    var email : String!
    var name : String!
    var mobile_number : String!
    var mob_prefix : String!
    var is_active : Bool!
    var email_verified : Bool!
    var created_at : String!
    var city_id : Int!
    var mobile_verified : Bool!
    var token : String!
    var country_id : Int!
    var state_id : Int!
    var expires_in : String!
    var token_type : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        name = json["name"].stringValue
        created_at = json["created_at"].stringValue
        updated_at = json["updated_at"].stringValue
        email = json["email"].stringValue
        id = json["id"].intValue
        mobile_number = json["mobile_number"].stringValue
        image = json["image"].stringValue
        mob_prefix = json["mob_prefix"].stringValue
        is_active = json["is_active"].boolValue
        email_verified = json["email_verified"].boolValue
        created_at = json["created_at"].stringValue
        city_id = json["city_id"].intValue
        mobile_verified = json["mobile_verified"].boolValue
        token = json["token"].stringValue
        country_id = json["country_id"].intValue
        state_id = json["state_id"].intValue
        expires_in = json["expires_in"].stringValue
        token_type = json["token_type"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if name != nil{
            dictionary["name"] = name
        }
        if created_at != nil{
            dictionary["created_at"] = created_at
        }
        if updated_at != nil{
            dictionary["updated_at"] = updated_at
        }
        if email != nil{
            dictionary["email"] = email
        }
        if id != nil{
            dictionary["id"] = id
        }
        if mobile_number != nil{
            dictionary["mobile_number"] = mobile_number
        }
        if image != nil{
            dictionary["image"] = image
        }
        if mob_prefix != nil{
            dictionary["mob_prefix"] = mob_prefix
        }
        if image != nil{
            dictionary["image"] = image
        }
        if image != nil{
            dictionary["image"] = image
        }
        if image != nil{
            dictionary["image"] = image
        }
        
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        first_name = aDecoder.decodeObject(forKey: "first_name") as? String
        created_at = aDecoder.decodeObject(forKey: "created_at") as? String
        middle_name = (aDecoder.decodeObject(forKey: "middle_name") as? String)!
        updated_at = aDecoder.decodeObject(forKey: "updated_at") as? String
        email = (aDecoder.decodeObject(forKey: "email") as? String)!
        last_name = aDecoder.decodeObject(forKey: "last_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        phone = aDecoder.decodeObject(forKey: "phone") as? String
        image = (aDecoder.decodeObject(forKey: "image") as? String)!
        
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if first_name != nil{
            aCoder.encode(first_name, forKey: "first_name")
        }
        if created_at != nil{
            aCoder.encode(created_at, forKey: "created_at")
        }
        if middle_name != nil{
            aCoder.encode(middle_name, forKey: "middle_name")
        }
        if updated_at != nil{
            aCoder.encode(updated_at, forKey: "updated_at")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if last_name != nil{
            aCoder.encode(last_name, forKey: "last_name")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if phone != nil{
            aCoder.encode(phone, forKey: "phone")
        }
        if image != nil{
            aCoder.encode(image, forKey: "image")
        }
        
    }
}


