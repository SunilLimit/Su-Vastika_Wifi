//
//  PriceModel.swift
//  Vastika
//
//  Created by Sanjeev on 17/08/22.
//

import Foundation
import SwiftyJSON

class PriceModel:NSObject,Codable{

    var today_start : String!
    var today_kwg : String!
    var today_saving : String!
    var today_end : String!
    
    var week1_start : String!
    var week1_kwg : String!
    var week1_saving : String!
    var week1_end : String!
    
    var week2_start : String!
    var week2_kwg : String!
    var week2_saving : String!
    var week2_end : String!
    
    var week3_start : String!
    var week3_kwg : String!
    var week3_saving : String!
    var week3_end : String!

    var week4_start : String!
    var week4_kwg : String!
    var week4_saving : String!
    var week4_end : String!

    var days30_start : String!
    var days30_kwg : String!
    var days30_saving : String!
    var days30_end : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        today_start = json["today_start"].stringValue
        today_end = json["today_end"].stringValue
        today_kwg = json["today_kwg"].stringValue
        today_saving = json["today_saving"].stringValue
        
        week1_start = json["week1_start"].stringValue
        week1_end  = json["week1_end"].stringValue
        week1_kwg = json["week1_kwg"].stringValue
        week1_saving = json["week1_saving"].stringValue
        
        week2_start = json["week2_start"].stringValue
        week2_end = json["week2_end"].stringValue
        week2_kwg = json["week2_kwg"].stringValue
        week2_saving = json["week2_saving"].stringValue
        
        
        week3_start = json["week3_start"].stringValue
        week3_end = json["week3_end"].stringValue
        week3_kwg = json["week3_kwg"].stringValue
        week3_saving = json["week3_saving"].stringValue
        
        week4_start = json["week4_start"].stringValue
        week4_end = json["week4_end"].stringValue
        week4_kwg = json["week4_kwg"].stringValue
        week4_saving = json["week4_saving"].stringValue
        
        days30_kwg = json["days30_kwg"].stringValue
        days30_saving = json["days30_saving"].stringValue
        days30_start = json["days30_start"].stringValue
        days30_end = json["days30_end"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        if today_kwg != nil{
            dictionary["today_kwg"] = today_kwg
        }
        if today_start != nil{
            dictionary["today_start"] = today_start
        }
        if today_end != nil{
            dictionary["today_end"] = today_kwg
        }
        if today_saving != nil{
            dictionary["today_saving"] = today_saving
        }
        
        if week1_start != nil{
            dictionary["week1_start"] = week1_start
        }
        if week1_end != nil{
            dictionary["week1_end"] = week1_end
        }
        if week1_kwg != nil{
            dictionary["week1_kwg"] = week1_kwg
        }
        if week1_saving != nil{
            dictionary["week1_saving"] = week1_saving
        }
        
        if week2_start != nil{
            dictionary["week2_start"] = week2_start
        }
        if week2_end != nil{
            dictionary["week2_end"] = week2_end
        }
        if week2_saving != nil{
            dictionary["week2_saving"] = week2_saving
        }
        if week2_kwg != nil{
            dictionary["week2_kwg"] = week2_kwg
        }
        
        if week3_start != nil{
            dictionary["week3_start"] = week3_start
        }
        if week3_end != nil{
            dictionary["week3_end"] = week3_end
        }
        if week3_kwg != nil{
            dictionary["week3_kwg"] = week3_kwg
        }
        if week3_saving != nil{
            dictionary["week3_saving"] = week3_saving
        }
        
        if week4_start != nil{
            dictionary["week4_start"] = week4_start
        }
        if week4_end != nil{
            dictionary["week4_end"] = week4_end
        }
        if week4_kwg != nil{
            dictionary["week4_kwg"] = week4_kwg
        }
        if week4_saving != nil{
            dictionary["week4_saving"] = week4_saving
        }
        
        
        if days30_start != nil{
            dictionary["days30_start"] = days30_start
        }
        if days30_end != nil{
            dictionary["days30_end"] = days30_end
        }
        if days30_kwg != nil{
            dictionary["days30_kwg"] = days30_kwg
        }
        if days30_saving != nil{
            dictionary["days30_saving"] = days30_saving
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        today_start = aDecoder.decodeObject(forKey: "today_start") as? String
        today_end = aDecoder.decodeObject(forKey: "today_end") as? String
        today_kwg = aDecoder.decodeObject(forKey: "today_kwg") as? String
        today_saving = aDecoder.decodeObject(forKey: "today_saving") as? String
        
        week1_start = (aDecoder.decodeObject(forKey: "week1_start") as? String)!
        week1_end = (aDecoder.decodeObject(forKey: "week1_end") as? String)!
        week1_kwg = (aDecoder.decodeObject(forKey: "week1_kwg") as? String)!
        week1_saving = (aDecoder.decodeObject(forKey: "week1_saving") as? String)!
        
        week2_start = (aDecoder.decodeObject(forKey: "week2_start") as? String)!
        week2_end = (aDecoder.decodeObject(forKey: "week2_end") as? String)!
        week2_kwg = (aDecoder.decodeObject(forKey: "week2_kwg") as? String)!
        week2_saving = (aDecoder.decodeObject(forKey: "week2_saving") as? String)!
        
        
        week3_start = (aDecoder.decodeObject(forKey: "week3_start") as? String)!
        week3_end = (aDecoder.decodeObject(forKey: "week3_end") as? String)!
        week3_kwg = (aDecoder.decodeObject(forKey: "week3_kwg") as? String)!
        week3_saving = (aDecoder.decodeObject(forKey: "week3_saving") as? String)!
        
        week4_start = (aDecoder.decodeObject(forKey: "week4_start") as? String)!
        week4_end = (aDecoder.decodeObject(forKey: "week4_end") as? String)!
        week4_kwg = (aDecoder.decodeObject(forKey: "week4_kwg") as? String)!
        week4_saving = (aDecoder.decodeObject(forKey: "week4_saving") as? String)!

        
        days30_start = (aDecoder.decodeObject(forKey: "days30_start") as? String)!
        days30_end = (aDecoder.decodeObject(forKey: "days30_end") as? String)!
        days30_kwg = (aDecoder.decodeObject(forKey: "days30_kwg") as? String)!
        days30_saving = (aDecoder.decodeObject(forKey: "days30_saving") as? String)!

    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if today_kwg != nil{
            aCoder.encode(today_kwg, forKey: "today_kwg")
        }
        if today_saving != nil{
            aCoder.encode(today_saving, forKey: "today_saving")
        }
        if today_start != nil{
            aCoder.encode(today_start, forKey: "today_start")
        }
        if today_end != nil{
            aCoder.encode(today_end, forKey: "today_end")
        }
        
        if week1_start != nil{
            aCoder.encode(week1_start, forKey: "week1_start")
        }
        if week1_end != nil{
            aCoder.encode(week1_end, forKey: "week1_end")
        }
        if week1_kwg != nil{
            aCoder.encode(week1_kwg, forKey: "week1_kwg")
        }
        if week1_saving != nil{
            aCoder.encode(week1_saving, forKey: "week1_saving")
        }
        
        
        if week2_start != nil{
            aCoder.encode(week2_start, forKey: "week2_start")
        }
        if week2_end != nil{
            aCoder.encode(week2_end, forKey: "week2_end")
        }
        if week2_kwg != nil{
            aCoder.encode(week2_kwg, forKey: "week2_kwg")
        }
        if week2_saving != nil{
            aCoder.encode(week2_saving, forKey: "week2_saving")
        }
        
        
        if week3_start != nil{
            aCoder.encode(week3_start, forKey: "week3_start")
        }
        if week3_end != nil{
            aCoder.encode(week3_end, forKey: "week3_end")
        }
        if week3_kwg != nil{
            aCoder.encode(week3_kwg, forKey: "week3_kwg")
        }
        if week3_saving != nil{
            aCoder.encode(week3_saving, forKey: "week3_saving")
        }
        
        if week4_start != nil{
            aCoder.encode(week4_start, forKey: "week4_start")
        }
        if week4_end != nil{
            aCoder.encode(week4_end, forKey: "week4_end")
        }
        if week4_kwg != nil{
            aCoder.encode(week4_kwg, forKey: "week4_kwg")
        }
        if week4_saving != nil{
            aCoder.encode(week4_saving, forKey: "week4_saving")
        }
        
        if days30_start != nil{
            aCoder.encode(days30_start, forKey: "days30_start")
        }
        if days30_end != nil{
            aCoder.encode(days30_end, forKey: "days30_end")
        }
        if days30_kwg != nil{
            aCoder.encode(days30_kwg, forKey: "days30_kwg")
        }
        if days30_saving != nil{
            aCoder.encode(days30_saving, forKey: "days30_saving")
        }
    }
}



