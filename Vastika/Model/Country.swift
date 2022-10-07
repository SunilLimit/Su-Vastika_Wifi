//
//  Country.swift
//  Vastika
//
//  Created by Mac on 15/09/21.
//

import Foundation
import SwiftyJSON

class Country:NSObject,Codable{

    var id : Int!
    var code : String!
    var name : String!
    var mob_prefix : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        code = json["code"].stringValue
        name = json["name"].stringValue
        mob_prefix = json["mob_prefix"].stringValue

    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if mob_prefix != nil{
            dictionary["mob_prefix"] = mob_prefix
        }
        if name != nil{
            dictionary["name"] = name
        }
        if code != nil{
            dictionary["code"] = code
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        code = aDecoder.decodeObject(forKey: "code") as? String
        mob_prefix = aDecoder.decodeObject(forKey: "mob_prefix") as? String
        name = (aDecoder.decodeObject(forKey: "name") as? String)!
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if mob_prefix != nil{
            aCoder.encode(mob_prefix, forKey: "mob_prefix")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
    }
}


class currencyModel:NSObject,Codable{

    var currency : String!
    var country : String!
    var code : String!
    var symbol : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        currency = json["currency"].stringValue
        country = json["country"].stringValue
        code = json["code"].stringValue
        symbol = json["symbol"].stringValue

    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if currency != nil{
            dictionary["currency"] = currency
        }
        if country != nil{
            dictionary[country] = country
        }
        if code != nil{
            dictionary["code"] = code
        }
        if symbol != nil{
            dictionary["symbol"] = symbol
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        currency = aDecoder.decodeObject(forKey: "currency") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        code = aDecoder.decodeObject(forKey: "code") as? String
        symbol = (aDecoder.decodeObject(forKey: "symbol") as? String)!
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if currency != nil{
            aCoder.encode(currency, forKey: "currency")
        }
        if country != nil{
            aCoder.encode(country, forKey: "country")
        }
        if symbol != nil{
            aCoder.encode(symbol, forKey: "symbol")
        }
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
    }
}

